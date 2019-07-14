#!/usr/bin/env dash

# if repo doesnt exist 
usage()
{
    echo "usage: legit-commit [-a] -m commit-message" 1>&2
    exit 0
}
if ! test -d ".legit"
then
    echo "legit-commit: error: no .legit directory containing legit repository exists" 1>&2
    exit 1

fi
# the number of args should always be 2 or 3. 

if [ $# -eq 2 ] 
then
    mflag="$1"
    message="$2"
    if [ $mflag != "-m" ] 
    then
        usage
    fi
elif [ $# -eq 3 ]
then
    aflag="$1"
    mflag="$2"
    message="$3"
    if [ $mflag != "-m" ] || [ $aflag != "-a" ] 
    then 
        usage 
    # update all the files currently in the index with the ones in the current_dir
    else 
        for file in .legit/.git/index/*
        do
            base_file=`basename $file`
        # check to see if it still exists first. 
            if test -f $base_file
            then 
                cp $base_file .legit/.git/index/$base_file
            fi
        done
    fi
else 
    usage
fi
# if the message is empty or it's just spaces
if [ -z "$message" ] || echo "$message"| egrep "^\ +$" > /dev/null
then 
    usage
    #everytime commit, need to save the  message 
# it should have changes from preivous commit 
# nothing to commit  - if theres no files or if theres no change use diff compare each file in the latest commit 
# take a snapshot 
# second case covers case where theres nothing in the index, not because its new
# but because files were removed
elif [ -z "$(ls -A .legit/.git/index)" ] && [ ! -f .legit/.git/commit_log.txt ]
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
        # checks all in index but what if missing from index?
        # index should always be more updated than latest commit at least
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
                if test -f "$file"
                then 
                    dif=`diff "$file" ".legit/.git/commits/.commit.$commit_number/$file"`
                fi 
                # theres a difference
                if [ "$dif" ]
                then
                    same="false"
                fi
            else
                same="false"
            fi 
        done
        # compare the number of files in index vs in latests commit
        num_files_index=`ls -1q .legit/.git/index| wc -l`
        num_files_latest_commit=`ls -1q .legit/.git/commits/.commit.$commit_number| wc -l`
        # files found in index same as in latest commit and nothing been removed from index
        #echo $num_files_index 
        #echo $num_files_latest_commit
        if [ $same = "true" ] && [ $num_files_index = $num_files_latest_commit ]
        then 
            echo "nothing to commit"
            exit 0
        # at least one file is different, so can safely commit 
        else 
            mkdir ".legit/.git/commits/.commit.$new_commit_number"
            # copy all files from the index into the new commit folder
            if [ $num_files_index != 0 ]
            then
                for file in .legit/.git/index/*
                do
                    base_file=`basename "$file"`
                    cp "$file" ".legit/.git/commits/.commit.$new_commit_number/$base_file"
                done
            fi
        fi

        # log the newest commit
        echo "Committed as commit $new_commit_number"
        # prepend from https://superuser.com/questions/246837/how-do-i-add-text-to-the-beginning-of-a-file-in-bash
        echo "$new_commit_number $message" | cat - ".legit/.git/commit_log.txt" > temp && mv temp ".legit/.git/commit_log.txt"

    # the first commit 
    else 
        mkdir ".legit/.git/commits/.commit.0"
        for file in .legit/.git/index/*
        do
            # take only the file name
            base_file=`basename "$file"`
            cp "$file" ".legit/.git/commits/.commit.0/$base_file"
        done
        # log the first commit 
        echo "Committed as commit 0"
        echo "0 $message" >> ".legit/.git/commit_log.txt"
    fi
fi
exit 0