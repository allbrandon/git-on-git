#!/usr/bin/env dash

# if repo doesnt exist 
if ! test -d ".legit"
then
    echo "legit-show: error: no .legit directory containing legit repository exists" 1>&2
    exit 1
# havent made any commits
elif ! test -f .legit/.git/commit_log.txt
then 
    echo "legit-show: error: your repository does not have any commits yet" 1>&2
    exit 1
# not the right number of arguments
elif [ $# != 1 ]
then 
    echo "usage: legit-show <commit>:<filename>" 1>&2
    exit 0
# checking if its a valid commit
# look at the logs of commits, get the first col and check if the supplied commit number exists in it
elif ! test `cat .legit/.git/commit_log.txt | cut -d ' ' -f1 | egrep "$(echo $1|cut -d':' -f1)"`
# check the commit log get the first col. if egrep the given number and its not there then it doesnt exist
then 
    commit_num=`echo $1|cut -d':' -f1`
    echo "legit-show: error: unknown commit '$commit_num'" 1>&2
    exit 1
# invalid filename 
elif ! test `echo $1 | cut -d ":" -f2 | egrep "^[a-zA-Z0-9][a-zA-Z0-9.-_]*"`
then 
    file=`echo $1 | cut -d ":" -f2-`
    echo "legit-show: error: invalid filename '$file'" 1>&2
    exit 1
# no colon
elif ! test `echo $1 | egrep ":"`
then
    echo "legit-show: error: invalid object $1" 1>&2
    exit 1

# given ':file' (no number )
elif ! test `echo $1 | cut -d ":" -f1`
then
# standard format 'commit_num:file'
    file=`echo $1|cut -d ":" -f2`
    # if the file doesnt exist in dex
    if ! test -f ".legit/.git/index/$file"
    then 
        echo "legit-show: error: '$file' not found in index" 1>&2
        exit 1
    # exists so print it out 
    else 
        cat .legit/.git/index/$file
    fi
else
    # check if the file exists in the commit
    commit_num=`echo $1|cut -d ":" -f1`
    file=`echo $1|cut -d ":" -f2`
    if ! test -f ".legit/.git/commits/.commit.$commit_num/$file"
    then
        echo "legit-show: error: '$file' not found in commit $commit_num" 1>&2
        exit 1
    else
        cat .legit/.git/commits/.commit.$commit_num/$file
    fi
fi

#repo -> no commit -> usage -> no colon : (invalid object) -> unknown commit -> not found in commit

# invalid filename after checking the commit number