#!/usr/bin/env dash

# if repo doesnt exist 
flag="$1"
message="$2"
if ! test -d ".legit"
then
    echo "legit-commit: error: no .legit directory containing legit repository exists" 1>&2
    exit 1
# if theres not the right number of args (2) or the first arg is not the -m flag
elif [ $# -ne 2 ] || [ $flag != "-m" ]
then 
    echo "usage: legit-commit [-a] -m commit-message" 1>&2
    exit 0
# if the message is empty or it's just spaces
elif [ -z "$message" ] || echo "$message"| egrep "^\ +$" > /dev/null
then 
    echo "usage: legit-commit [-a] -m commit-message" 1>&2
    exit 0
    #everytime commit, need to save the  message 

# it should have changes from preivous commit 
# nothing to commit  - if theres no files or if theres no change use diff compare each file in the latest commit 
# take a snapshot 
elif [ -z "$(ls -A .legit/.git/index)" ] 
then 
    echo "nothing to commit"
    exit 0

# implementation 
else 
# check if any commits have been made (folder exists)
    if result=`ls -a .legit/.git/commits | egrep "^\.commit\.[0-9]+"`
    then
        # get the latest commit number to find the next one and make the folder
        commit_number=`echo $result | sed s/\.commit\.//g|tr ' ' '\n'| sort -n | tail -1`
        new_commit_number=$((commit_number + 1))
        # check if theres anything to change
        same="true"
        for file in .legit/.git/index/*
        do
            # assume theres nothing to commit. If there is then 'same' variable
            # will be false 
            #same=1
            # take only the file name
            file=`basename $file`
            # the current file in index exists in latest commit so we need to check
            # if its actually a new version
            if test -f ".legit/.git/commits/.commit.$commit_number/$file"
            then 
                # if its the same (no output with diff) then nothing to commit
                # does it need ! ?
                dif=`diff "$file" ".legit/.git/commits/.commit.$commit_number/$file"`
                # theres a difference
                if [ "$dif" ]
                then
                    same="false"
                    #unset dif 
                fi
            else
                same="false"
            fi 
        done
        if [ $same = "true" ] 
        then 
            echo "nothing to commit"
            exit 0
        # at least one file is different, so can safely commit 
        else 
            mkdir ".legit/.git/commits/.commit.$new_commit_number"
            # copy all files from the index into the new commit folder
            for file in .legit/.git/index/*
            do
                file=`basename $file`
                cp $file ".legit/.git/commits/.commit.$new_commit_number/$file"
            done
        fi

        # log the newest commit
        echo "Committed as commit $new_commit_number"
        echo "$new_commit_number $message" >> ".legit/.git/commit_log.txt"

    # the first commit 
    else 
        mkdir ".legit/.git/commits/.commit.0"
        for file_full in ".legit/.git/index/*"
        do
            # take only the file name
            file=`echo $file_full | cut -d "/" -f4`
            cp $file ".legit/.git/commits/.commit.0/$file"
        done
        # log the first commit 
        echo "Committed as commit 0"
        echo "0 $message" >> ".legit/.git/commit_log.txt"
    fi
fi