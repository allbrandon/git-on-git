#!/bin/dash
sh snapshot-save.sh

cd ".snapshot.$1"
echo "Restoring snapshot $1"
for file in * 
do
    cp $file ../$file 
done
#get all the files from the snapshot and cp it to the current dir
