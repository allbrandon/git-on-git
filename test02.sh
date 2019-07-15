#!/usr/bin/env dash
echo "----- Running test02.sh ------"

echo "Running Test #1: legit-commit with no existing repo"
rm -rf ".legit"
echo ye > normalfile.txt
./legit-commit -m a
echo "Running Test #: legit-commit with nothing git-added"
./legit-init
./legit-commit -m com1
echo "Running Test #: legit-commit first commit 0"
./legit-add normalfile.txt
./legit-commit -m com1

echo "Running Test #: legit-commit readding same contents"
./legit-add normalfile.txt
./legit-commit -m com2
echo "Running Test #: legit-commit: same file name as prev but modified file"
echo ye >> normalfile.txt
./legit-add normalfile.txt
./legit-commit -m com1


echo "Running Test #: legit-commit but files same as prev commit"
./legit-commit -m com1
echo "Running Test #: legit-commit wrong usage, i.e. just ./legit-commit.sh or ./legit-commit lkm or ./legit-commit -m lda"
./legit-commit
./legit-commit ald
./legit-commit ao a as
