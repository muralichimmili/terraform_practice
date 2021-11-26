#! bin/bash

  timestamp=$(date +%d_%m_%Y_%H_%M_%S)

  echo this data is to log file > /shellscripting/${timestamp}.log

  echo this is extra data to log file >> /shellscripting/${timestamp}.log

  date >> /shellscripting/${timestamp}.log
