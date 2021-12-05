#! /bin/bash
sudo su
yum update -y
yum install httpd -y
cd /var/www/html/
echo "hello from webserver vpc" > index.html
service start httpd
chkconfig httpd on