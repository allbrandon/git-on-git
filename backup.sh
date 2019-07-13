#!/bin/bash

filename="$1"

# if the .0 or .1 or .2, etc already exists, then you need to add one to it
# for the new file name
if result=`ls -a|egrep "^\.$filename\.[0-9]+"`
#echo "$result"
then 
    # replace the filename and dots with a space so you are left with only the number
    # seperate into new lines so it can be sorted, then tail to take the last one
    # which should be the biggest
    # then add one to get the new file name's version number
    number=`echo $result | sed s/\.$filename\.//g|tr ' ' '\n'| sort -n | tail -1`
    #echo $number
    #the next backup number will be added by 1
    number=$((number + 1))
    cp $filename > ".$filename.$number"
    echo "Backup of '$filename' saved as '.$filename.$number'"
else 
    cp $filename > ".$filename.0"
    echo "Backup of '$filename' saved as '.$filename.0'"
fi