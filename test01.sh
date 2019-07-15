#!/usr/bin/env dash
echo "----- Running test01 ------"
# test no repo 
echo "Running Test #1: legit-add with no existing repo"
rm -rf ".legit"
echo ye > normalfile.txt
2041 legit-add normalfile.txt > reference_stdout 2> reference_stderr
./legit-add normalfile.txt > my_stdout 2> my_stderr 
diff my_stderr reference_stderr 
diff my_stdout reference_stdout 
# test normal case add (should overwrite)
echo "Running Test #2: legit-add with no existing normal file"
./legit-init 
2041 legit-add nonexistant_file.txt > reference_stdout 2> reference_stderr
./legit-add nonexistant_file.txt > my_stdout 2> my_stderr 
diff my_stderr reference_stderr 
diff my_stdout reference_stdout 
echo "Running Test #3: legit-add with existing normal file"
rm -rf ".legit"
2041 legit-init
2041 legit-add normalfile.txt > reference_stdout 2> reference_stderr
rm -rf ".legit"
./legit-init
./legit-add normalfile.txt > my_stdout 2> my_stderr 
diff my_stderr reference_stderr 
diff my_stdout reference_stdout 
#legit-add: error: invalid filename '&h.txt'
# usage: legit-add <filenames>

# also happens if you just type legit-add
# test - invoke 'usage should be __'
echo "Running Test #4: legit-add with wrong usage"
2041 legit-add > reference_stdout 2> reference_stderr
./legit-add > my_stdout 2> my_stderr 
diff my_stderr reference_stderr 
diff my_stdout reference_stdout 

# test invalid filename 
echo "Running Test #5: legit-add with invalid filename '.' at the start"
echo bad > .badfile
2041 legit-add .badfile > reference_stdout 2> reference_stderr
./legit-add .badfile > my_stdout 2> my_stderr 
diff my_stderr reference_stderr 
diff my_stdout reference_stdout 

echo "Running Test #6: legit-add with invalid filename '_' at the start"
echo bad > _badfile
2041 legit-add _badfile > reference_stdout 2> reference_stderr
./legit-add _badfile > my_stdout 2> my_stderr 
diff my_stderr reference_stderr 
diff my_stdout reference_stdout 
#usage: legit-add <filenames>

# This test doesn't work as it should due to reference's implementation
#echo "Running Test #7: legit-add with invalid filename '-' at the start"
#echo bad > -badfile
#2041 legit-add -badfile > reference_stdout 2> reference_stderr
#./legit-add -badfile > my_stdout 2> my_stderr 
#diff my_stderr reference_stderr 
#diff my_stdout reference_stdout 
#no output
echo "Running Test #8: legit-add with '.' inside filename"
rm -rf ".legit"
2041 legit-init
echo ok > ok.file.txt
2041 legit-add ok.file.txt > reference_stdout 2> reference_stderr
rm -rf ".legit"
./legit-init
./legit-add ok.file.txt > my_stdout 2> my_stderr
diff my_stderr reference_stderr 
diff my_stdout reference_stdout  

#no output
echo "Running Test #9: legit-add with '_' inside filename"
rm -rf ".legit"
2041 legit-init
echo ok> ok_file.txt
2041 legit-add ok_file.txt > reference_stdout 2> reference_stderr
rm -rf ".legit"
./legit-init
./legit-add ok_file.txt > my_stdout 2> my_stderr 
diff my_stderr reference_stderr 
diff my_stdout reference_stdout 


#no output
echo "Running Test #10: legit-add with '-' inside filename"
rm -rf ".legit"
2041 legit-init
echo ok > ok-file.txt
2041 legit-add ok-file.txt > reference_stdout 2> reference_stderr
rm -rf ".legit"
./legit-init
./legit-add ok-file.txt > my_stdout 2> my_stderr 
diff my_stderr reference_stderr 
diff my_stdout reference_stdout 

#legit-add: error: 'test_dir' is not a regular file
echo "Running Test #11: legit-add with a non-regular file"

mkdir "test-dir"
2041 legit-add test-dir > reference_stdout 2> reference_stderr
./legit-add test-dir > my_stdout 2> my_stderr 
diff my_stderr reference_stderr 
diff my_stdout reference_stdout 

# legit-add: error: invalid filename '_k'
echo "Running Test #12: legit-add: order of error. if the file name is wrong and it doesnt exist"
2041 legit-add test-dir> reference_stdout 2> reference_stderr
./legit-add test-dir > my_stdout 2> my_stderr 
diff my_stderr reference_stderr 
diff my_stdout reference_stdout 
rmdir "test-dir"

echo "Running Test #13: legit-add: if one argument is bad, then fail everything"
2041 legit-add ok.file.txt _badfile > reference_stdout 2> reference_stderr
./legit-add ok.file.txt _badfile > my_stdout 2> my_stderr 
diff my_stderr reference_stderr 
diff my_stdout reference_stdout 
#
#
## can assume that the files they pass in wont start with 
#
#
## file does not exist 
##2041 legit-add o
##legit-add: error: can not open 'o'
#
##2041 legit-add .h..txt l konk jnlm;
##legit-add: error: invalid filename '.h..txt'
#
## what happens if you type legit-add (correctfile) (incorrectfile)
## which error pops up first? Does it matter -> so it loooks like it looks at the first one that fails. if it does then it doesn't
## run anything after it. test to see if the invalid one is in the 2nd arg will it still add the first arg?
## if theres one wrong one in the whole thing it will just fail.  (for if the file doesnt exist and if its an invalid filename)
## it prioritises error message based on what comes first in the list of arguments 
#
#
## 2041 legit-add >
## -bash: syntax error near unexpected token `newline'
#
## sh legit-add
#