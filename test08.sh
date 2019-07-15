#!/usr/bin/env dash
# git -rm --cached
echo "----- Running test08.sh ------"

echo "Running Test #1: legit-rm --cached a -> legit-rm --cached a"
# cache then cache again

echo "Running Test #1: legit-rm a -> legit-rm --cached a"
# normal rm then cache

echo "Running Test #1: legit-rm --cached a -> legit-rm a"
# cachen then normal
