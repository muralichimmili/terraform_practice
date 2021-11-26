#! bin/bash

  timestamp=$(date +%d_%m_%Y_%H_%M_%S)
  echo "this is test data to text file">>$(echo ~)/${timestamp}.log
  echo "this is extra data to log file">>$(echo ~)/${timestamp}.log
  date>>$(echo ~)/${timestamp}.log
