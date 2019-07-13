#!/bin/dash
if result=`ls -a|egrep "^\.snapshot\.[0-9]+"`
then
    backup_number=`echo $result | sed s/\.snapshot\.//g|tr ' ' '\n'| sort -n | tail -1`
    backup_number=$((backup_number + 1))
    echo "Creating snapshot $backup_number"
    mkdir ".snapshot.$backup_number"

    for file in *
    do
        if [ ! -d "$file" ] && [ "$file" != "snapshot-save.sh" ] && [ "$file" != "snapshot-load.sh" ]
        then 
            cp $file ./.snapshot.$backup_number/$file
        fi
    done
else 
    echo "Creating snapshot 0"
    mkdir ".snapshot.0"
    for file in *
    do
        if [ ! -d "$file" ] && [ "$file" != "snapshot-save.sh" ] && [ "$file" != "snapshot-load.sh" ]
        then 
            cp $file ./.snapshot.0/$file
        fi
    done
fi