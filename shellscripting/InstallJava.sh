#! /bin/bash

sudo apt update

if [ $(echo $?) != 0] ; then

  sudo apt install -y default-jre

  if [ $(echo $?) = 0] ; then

          echo java installed sucessfully
  else
         echo java not installed sucessfully
  fi