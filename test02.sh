#!/usr/bin/env dash
echo "----- Running test02.sh ------"

echo "Running Test #: legit-commit normal case"

echo "Running Test #1: legit-commit with no existing repo"

echo "Running Test #: legit-commit with nothing git-added"

# nothing to commit -> not stderr
echo "Running Test #: legit-commit but files same as prev commit?"

echo "Running Test #: legit-commit wrong usage, i.e. just ./legit-commit.sh or ./legit-commit lkm or ./legit-commit -m lda"
# not 3 args -> fail

# 2041 legit-commit -m "klm lfw" -> see how this works (how many args, does the msg contain " " )




# 2041 legit-commit -> legit-commit [-a] -m commit-message
# so basically it should always be in -m ELSE you give usage error

# 2041 legit-commit -m message -> nothing to commit (if theres nothing git added)
# keep a file that keeps track of what commit number it is "Committed as commit 1" "1 d" (commit number message)
# ORDER OF ERROR: 
#CHECKS FOR USAGE FIRST