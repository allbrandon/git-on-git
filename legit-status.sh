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
   # mkdir temp_dir
   cur_files=`echo $(ls -p | grep -v /)
   # |tr " " "\n"`
   # final_file_list=`cat .legit/.git/files_history.txt temp_dir/tempppp.txt|egrep -v "tempppp.txt"|sort|uniq`
   # rm -rf temp_dir
    for file in .legit/.git/commits/.commit.$latest_commit/*
    do
        # look at the file if its not in either index or cur dir
        base_file=`basename $file`
        if [ ! -f "legit/.git/index/$base_file" ] && [ ! -f "$base_file" ]
        then
            deleted_files="${deleted_files} $base_file"
            
        elif [ -f "legit/.git/index/$base_file" ] && [ ! -f "$base_file" ]
        then
            deleted_files="${deleted_files} $base_file"
        fi
    done 
    # add the deleted files and normal and put them into one big list, sorted
    final_list=`echo "$deleted_files $cur_files"| tr ' ' '\n'|sort|uniq`
    for file in $final_list
    do 

        if [ -f ".legit/.git/index/$file" ]
        then
            # check if the files exist in current directory and index first
            if [ -f "$file" ] && [ -f ".legit/.git/commits/.commit.$latest_commit/$file" ]
            then
                # look at current dir vs repo
                dif_cur_repo=`diff "$file" ".legit/.git/commits/.commit.$latest_commit/$file"` 
                dif_cur_index=`diff "$file" ".legit/.git/index/$file"`
                dif_index_repo=`diff ".legit/.git/commits/.commit.$latest_commit/$file" ".legit/.git/index/$file"`
                # file changed
                if [ "$dif_cur_repo" ]
                then     
                    if [ "$dif_cur_index" ] && [ "$dif_index_repo" ]
                    then 
                        echo "$file - file changed, different changes staged for commit"
                    elif [ "$dif_cur_index" ]
                    then 
                        # current index has diff vers to cur dir 
                        echo "$file - file changed, changes not staged for commit"
                    else 
                    #current dir has same vers as index
                    echo "$file - file changed, changes staged for commit"
                    fi
                else 
                    echo "$file - same as repo"
                fi
            # not in cwd but in index
            elif [ ! -f "$file" ]
            then 
                echo "$file - file deleted"
            #new file
            else 
                echo "$file - added to index"
            fi
                
        # deletion 
        # a - deleted -> gone from index & cwd
        # a - file deleted -> gone from cwd but in index
        # if theres a file in the latest commit thats not in either index/cur dir its deleted
        elif [ ! -f ".legit/.git/index/$file" ] && [ ! -f "$file" ] && [ -f ".legit/.git/commits/.commit.$latest_commit/$file" ]
        then
            echo "$file - deleted"
        else 
            echo "$file - untracked"
        fi
    done
fi
exit 0