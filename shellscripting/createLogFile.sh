#! bin/bash

  timestamp=$(date +%d_%m_%Y_%H_%M_%S)

  echo "this data is to log file" > ${timestamp}.log

  echo "this is extra data to loig file" >> ${timestamp}.log

  date >> ${timestamp}.log
