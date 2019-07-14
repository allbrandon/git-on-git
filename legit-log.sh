#!/usr/bin/env dash

# if repo doesnt exist 
if ! test -d ".legit"
then
    echo "legit-log: error: no .legit directory containing legit repository exists" 1>&2
    exit 1
# legit-log: error: your repository does not have any commits yet
elif ! test -f .legit/.git/commit_log.txt
then 
    echo "legit-log: error: your repository does not have any commits yet" 1>&2
    exit 1
elif [ $# != 0 ]
then 
    echo "usage: legit-log" 1>&2
    exit 0
else 
    cat .legit/.git/commit_log.txt
fi
exit 0