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
        echo "legit-add: error: can not open '$file'" 1>&2
        exit 1
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
    cp $file ./.legit/.git/index/$file
done