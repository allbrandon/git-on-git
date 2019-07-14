# a - deleted -> gone from index & cwd
# a - file deleted -> gone from cwd but in index
# keep a txt file -> egrep ?
# untracked -> hasn't been added yet (keep a track of all files?)
#!/usr/bin/env dash


# if repo doesnt exist 
if ! test -d ".legit"
then
    echo "legit-status: error: no .legit directory containing legit repository exists" 1>&2
    exit 1
elif ! test -f .legit/.git/commit_log.txt
then 
    echo "legit-status: error: your repository does not have any commits yet" 1>&2
    exit 1
# go through
else 
latest_commit=`cat .legit/.git/commit_log.txt| head -1| cut -d" " -f1`
for file in *
do 

    # current dir has a diff vers to 
    
    if 
    then 
        echo "$file - file changed, different changes staged for commit"
    # check if the files exist in current directory and index first
    elif [ -f "$file" ] && [ -f ".legit/.git/index/$file" ]
    then 
        if [ diff "$file" ".legit/.git/index/$file" ]
        then        
            echo "$file - file changed, changes not staged for commit"
        else 
            echo "$file - file changed, changes staged for commit"
        fi    
    elif [ -f "$file" ] && [ -f ".legit/.git/commits/.commit.$latest_commit/$file" ]
    then
        if [ ! diff "$file" ".legit/.git/commits/.commit.$latest_commit/$file" ]
        then         
            echo "$file - same as repo"
        fi
    elif [ -f .legit/.git/index/$file ]
    then 
        echo "$file - added to index"
    else 
        echo "$file - untracked"
    fi 

done
exit 0