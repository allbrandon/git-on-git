#!/usr/bin/env dash
# remember to change this after

# create a repo (folder )
# if theres already one print the error message 

if test -d ".legit"
then
    echo "legit-init: error: .legit already exists"
else 
    mkdir ".legit"
    # go into the .legit directory and make the .git directory
    cd ".legit"
    mkdir ".git"
    echo "Initialized empty legit repository in .legit"
fi