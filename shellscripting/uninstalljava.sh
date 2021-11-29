#! /bin/bash

sudo apt purge -y openjdk-11-*
sudo apt remove -y --autoremove openjdk-11-*
java -version
if [ $? -ne 0 ]; then
  echo java uninstalled sucessfully
  else
    echo java not uninstalled sucessfully
  fi