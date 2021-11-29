#! /bin/bash
dir=$(date +%d_%m_%Y)
filename=$(date +%d_%m_%Y_%H_%M_%S).log
 if [ ! -e $dir ]; then
    mkdir $dir
    echo "Created Directory successfully"
 else
   echo "$dir already exist in the system"
 fi

  if [ ! -e $filename ]; then
       touch "/${dir}/${filename}"
       echo "${filename} created successfully"
     else
       echo "${filename} already exist"
     fi


