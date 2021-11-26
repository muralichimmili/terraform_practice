#! bin/bash

  timestamp=$(date +%d_%m_%Y_%H_%M_%S)
  echo "this is test data to text file" >> /home/devops/sample.log
  echo "this is extra data to log file" >> /home/devops/sample.log
  date >> /home/devops/sample.log
