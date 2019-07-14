#!/usr/bin/env dash
usage()
{
    echo "usage: legit-rm [--force] [--cached] <filenames>" 1>&2
    exit 0
}
# if repo doesnt exist 
if ! test -d ".legit"
then
    echo "legit-rm: error: no .legit directory containing legit repository exists" 1>&2
    exit 1
elif ! test -f .legit/.git/commit_log.txt
then 
    echo "legit-rm: error: your repository does not have any commits yet" 1>&2
    exit 1
fi

# change the flags to short name https://stackoverflow.com/questions/12022592/how-can-i-use-long-options-with-the-bash-getopts-builtin
for arg in "$@"
do
    shift 
    case "$arg" in 
    "--force")  set -- "$@" "-f" ;;
    "--cached") set -- "$@" "-c" ;;
    *)          set -- "$@" "$arg" ;;
    esac 
done 
# https://www.oreilly.com/library/view/bash-cookbook/0596526784/ch13s02.html
while getopts :fc opt
do 
    case "$opt" in 
        "f")  force=1
            ;;
        "c")  cached=1
            ;; 
        "?") usage 
            ;;
        esac >&2
done 
# optind holds number of options parsed by last call
# shift it to remove options already ahndled
shift $(($OPTIND -1))

#check all the files first
latest_commit=`cat .legit/.git/commit_log.txt| head -1| cut -d" " -f1`
for file in $*
do
    # check for invalid file name
    if ! test `echo $file | egrep "^[a-zA-Z0-9][a-zA-Z0-9.-_]*"`
    then 
        echo "legit-rm: error: invalid filename '$file'" 1>&2
        exit 1
    # the file wanted is not in the index
    elif ! test -f .legit/.git/index/$file
    then
        echo "legit-rm: error: '$file' is not in the legit repository" 1>&2
        exit 1 
    fi

    # check if file exists first in current directory and index then check if theyre diff
    if [ -f $file ] && [ -f .legit/.git/index/$file ]
    then 
        diff_cur_index=`diff "$file" ".legit/.git/index/$file"`
    else 
        # they will be diff if one/both doesnt exist
        diff_cur_index=1
    fi 
    # check if latest commit and index are diff
    if [ -f .legit/.git/commits/.commit.$latest_commit/$file ] && [ -f .legit/.git/index/$file ]
    then
    # check if index and latest commit are diff
        diff_index_repo=`diff ".legit/.git/commits/.commit.$latest_commit/$file" ".legit/.git/index/$file"`
    else 
        diff_index_repo=1
    fi
    # theres a difference in both
    if [ "$diff_cur_index" ] && [ "$diff_index_repo" ]
    then 
        if [ ! "$force" ]
        then 
            echo "legit-rm: error: '$file' in index is different to both working file and repository" 1>&2
            exit 1   
        fi
    fi 
    if [ ! "$cached" ]
    then 
    # the file in 
        if [ "$diff_cur_index" ]
        then
            if [ ! "$force" ]
            then 
                echo "legit-rm: error: '$file' in repository is different to working file" 1>&2
                exit 1 
            fi
        # the file in index is diff from the latest commit 
        elif [ "$diff_index_repo" ]
        then
            if [ ! "$force" ]
            then 
                echo "legit-rm: error: '$file' has changes staged in the index" 1>&2
                exit 1 
            fi
        fi
    fi
done

# now that files are all error-checked, remove them from both index and cwd 
for file in $*
do
    # if no cache flag given remove from cwd
    if [ ! "$cached" ]
    then 
        rm "$file"
    fi
    rm ".legit/.git/index/$file"
done
exit 0