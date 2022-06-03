# This script will check the files in the PR commit for any Jupyter Notebook files are present.
# Fails the code if there is any files which has .ipynb extension

#!/bin/bash

currentbranch="$1"
echo "current branch is "$currentbranch
flag=false

# Gets the list of file difference for the current branch and outputs to file.
#Only stdout is redirected to file, any error from the git diff command will stop the complete execution.
git diff --name-only --diff-filter=AMR origin/$currentbranch..HEAD  1> shafile.txt

# loops through the file an gets the message.

while IFS= read -r line;
  do

    if [ "$line" == "*.[iI][Pp][Yy][Nn][Bb]" ];
    then
      echo "\e[1;31m ###################################################################### \e[0m"
      echo "\e[1;31m File :'$line' is Jupyter notebook. Notebooks are prevented from being committed by the branch policies. Please remove the file. \e[0m"
      echo "\e[1;31m ###################################################################### \e[0m"
      flag=false

    else
      echo "\e[1;32m File: '$line' could be commited. \e[0m"
      flag=true

    fi
  done < ./shafile.txt

if [ "$flag" = true ]
  then
    echo "\e[1;32m Commit has passed file extension validation. \e[0m"
elif [ ! -s shafile.txt ] && [ "$flag" = false ]
  then
    echo "\e[1;32m No output from git command, Passing the test .\e[0m"
else
    echo "\e[1;31m Commit has failed file extension validation.\e[0m"
    exit 1
fi