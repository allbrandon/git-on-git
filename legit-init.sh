#!/usr/bin/env dash
# remember to change this after

# create a repo (folder )
# if theres already one print the error message 

if [ $# != 0 ]
then 
    echo "usage: legit-init" 1>&2
    exit 0
elif test -d ".legit"
then
    echo "legit-init: error: .legit already exists" 1>&2
    exit 1
else 
    mkdir ".legit"
    # go into the .legit directory and make the .git directory
    mkdir ".legit/.git"
    mkdir ".legit/.git/index"
    mkdir ".legit/.git/commits"
    echo "Initialized empty legit repository in .legit"
fi
