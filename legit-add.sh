#!/usr/bin/env dash

# if repo doesnt exist 
if ! test -d ".legit"
then
    echo "legit-add: error: no .legit directory containing legit repository exists" 1>&2
    exit 1
# if the user only types ./legit-add.sh, tell them the correct usage
elif [ $# = 0 ]
then 
    echo "usage: legit-add <filenames>" 1>&2
    exit 0
fi

# Loop #1 - validate all the files
for file in $@ 
do
    # check for invalid file name
    if ! test `echo $file | egrep "^[a-zA-Z0-9][a-zA-Z0-9.-_]*"`
    then 
        echo "legit-add: error: invalid filename '$file'" 1>&2
        exit 1
    # if it doesnt exist legit-add: error: can not open '$file'
    elif ! test -e "$file"
    then 
        # check if its been manually deleted 
        if test -f .legit/.git/index/$file 
        then 
            rm .legit/.git/index/$file 
        else
            echo "legit-add: error: can not open '$file'" 1>&2
            exit 1
        fi
    # if it exists make sure its a file 
    elif ! test -f "$file"
    then 
        echo "legit-add: error: '$file' is not a regular file" 1>&2
        exit 1
    fi
done

# Loop #2 - now that all the files pass the test, we can copy them into the index.
for file in $@ 
do
# Assuming that the index dir is there (from init) and not manipulated with
    # check again to see if the files here and not removed 
    if test -f $file
    then
        # everytime we get a new file_name, append to files_history.txt, to use for legit-status
        if [ -f .legit/.git/files_history.txt ]
        then
            file_name=`cat .legit/.git/files_history.txt | egrep $file`
        fi
        # if egrep gets nothing then its a new file name
        if [ ! "$file_name" ]
        then
            echo "$file" >> .legit/.git/files_history.txt
        fi
        cp "$file" .legit/.git/index/$file
    fi
done
exit 0

