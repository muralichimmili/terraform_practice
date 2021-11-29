#! /bin/bash

sudo apt update
java -version
if [ $? -ne 0]; then

  sudo apt install -y default-jre

  if [ $? -eq 0]; then

          echo java installed sucessfully
  else
         echo java not installed sucessfully
  fi
  else
    echo "java already installed"
  fi