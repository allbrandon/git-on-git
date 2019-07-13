#!/usr/bin/env dash

# if repo doesnt exist 
# needs to be legit-commit -m kfmwaf
flag="$1"
message="$2"
if ! test -d ".legit"
then
    echo "legit-add: error: no .legit directory containing legit repository exists" 1>&2
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
else 
# check if any commits have been made (folder exists)
    if result=`ls -a .legit/.git/commits | egrep "^\.commit\.[0-9]+"`
    then
        # get the latest commit number to find the next one and make the folder
        commit_number=`echo $result | sed s/\.commit\.//g|tr ' ' '\n'| sort -n | tail -1`
        commit_number=$((commit_number + 1))
        echo "Committed as commit $commit_number\n"
        mkdir ".commit.$commit_number"

        # copy all files from the index into the new commit folder
        for file in .legit/.git/index/*
        do
            if [ ! -d "$file" ]
                cp $file .legit/.git/commits/.commit.$commit_number/$file
            fi
        done
        # log the newest commit
        "$commit_number $message\n" >> ./legit/.git/commit_log 
    # the first commit 
    else 
        echo "Committed as commit 0\n"
        mkdir ".commit.0"
        for file in .legit/.git/index/*
        do
            if [ ! -d "$file" ] 
            then 
                cp $file .legit/.git/commits/.commit.0/$file
            fi
        done
        # log the first commit 
        "0 $message\n" >> ./legit/.git/commit_log 
    fi
fi