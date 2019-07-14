#!/usr/bin/env dash
echo "----- Running test04.sh ------"

# if theres no git repo
# if theres no commit-log created (e.g. no commits have been made yet)
#legit-log: error: your repository does not have any commits yet
echo "Running Test #: legit-show no args provided"
#2041 legit-show a:c
echo "Running Test #: legit-show first part is non-numerical"
#legit-show: error: unknown commit 'a'
echo "Running Test #: legit-show first part is not a valid commit number"
#legit-show: error: unknown commit '22'

echo "Running Test #: legit-show: no ':'"
#2041 legit-show hey
#legit-show: error: invalid object hey

#2041 legit-show 0:a
#legit-show: error: 'a' not found in commit 0
echo "Running Test #: legit-show: valid commit number, but invalid file"

echo "Running Test #: legit-show: invalid commit number, valid file"

# 2041 legit-show :hey
echo "Running Test #: legit-show: NO commit number provided - show specified existing from index"

#2041 legit-show :a
#legit-show: error: 'a' not found in index
echo "Running Test #: legit-show: NO commit number provided - specified file doesnt exist in index"

#2041 legit-show 0:
#legit-show: error: invalid filename '' (steal from git-add)
echo "Running Test #: legit-show: Commit number is correct, filename is invalid"
echo "Running Test #: legit-show: Commit number is incorrect, filename is invalid"
echo "Running Test #: legit-show: No commit number, filename is invalid"


