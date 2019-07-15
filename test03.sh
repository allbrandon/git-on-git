#!/usr/bin/env dash
echo "----- Running test03.sh ------"

echo "Running Test #: legit-log: no git repo"
# if theres no git repo

rm -rf ".legit"
echo ye > normalfile.txt
./legit-log
echo "Running Test #: legit-log: no commits made"
# if theres no commit-log created (e.g. no commits have been made yet)
./legit-init
./legit-log 

echo "Running Test #: legit-log: normal"
# normal case 
echo ye > normalfile.txt
./legit-add normalfile.txt
./legit-commit -m com1
./legit-log

echo "Running Test #: legit-log: usage error"
./legit-log sla s
