#! /bin/bash
dir=$(date +%d)
file=$(date +%d_%m_%Y_%H_%M_%S)
 if [! -e $dir];then
    mkdir $dir
    echo "Created Directory successfully"
 else
   echo "$dir already exist in the system"
 fi

  if[! -e $file.log];then
       touch $file.log
       echo "$file.log created successfully"
     else
       echo "$file.log already exist"
     fi


