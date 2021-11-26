#! bin/bash

  timestamp=$(date +%d_%m_%Y_%H_%M_%S)
  echo "this is test data to text file">>${timestamp}.log
  echo "this is extra data to log file">>${timestamp}.log
  date>>${timestamp}.log
