#!/usr/bin/env dash
# git -rm
echo "----- Running test06.sh ------"

echo "Running Test #1: legit-rm with no existing repo"

echo "Running Test #2: legit-rm: with no committs"
#legit-rm: error: your repository does not have any commits yet

echo "Running Test #1: legit-rm: with invalid filename"
# legit-rm: error: invalid filename '_'

echo "Running Test #: legit-rm with wrong usage"
#usage: legit-rm [--force] [--cached] <filenames>


echo "Running Test #: legit-rm: specified file in current dir but not in index"
#legit-rm: error: 'a' is not in the legit repository

echo "Running Test #: legit-rm: with one not in index"
# where 'aa' is in index
#2041 legit-rm aa hey
#legit-rm: error: 'hey' is not in the legit repository

echo "Running Test #: legit-rm: specified file not in current dir or index"
#2041 legit-rm dkmawdoiawmd
#legit-rm: error: 'dkmawdoiawmd' is not in the legit repository

echo "Running Test #: legit-rm with one not in current dir"

echo "Running Test #: legit-rm: specified file diff in curr directory, index and latest commit"
#legit-rm: error: '$file' in index is different to both working file and repository

echo "Running Test #: legit-rm when currrent directory has diff file"
#legit-rm: error: 'a' in repository is different to working file

echo "Running Test #: legit-rm: specified file updated in index with current directory but not committed"
# added but not comitted. cross check with the latest commit 
#legit-rm: error: 'a' has changes staged in the index
