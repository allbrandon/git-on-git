#!/usr/bin/env dash
# run the 
# ensure that the directory doesn't exist initially 
rm -rf ".legit"
echo "----- Running test00.sh ------"
# 
echo "Running Test #1: legit-init with no existing directory"
2041 legit-init > reference_stdout 2> reference_stderr
rm -rf ".legit"
./legit-init.sh > my_stdout 2> my_stderr 
diff my_stderr reference_stderr 

echo "Running Test #2: legit-init with existing directory"
./legit-init.sh > my_stdout 2> my_stderr 
2041 legit-init > reference_stdout 2> reference_stderr 
diff my_stdout reference_stdout 

rm -rf ".legit"

echo "Running Test #3: incorrect usage"
./legit-init.sh da > my_stdout 2> my_stderr 
2041 legit-init da > reference_stdout 2> reference_stderr 
diff my_stdout reference_stdout 
#wagner % 2041 legit-init ;1
#legit-init: error: .legit already exists