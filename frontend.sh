#!/bin/bash

echo "I am frontend"

# this command will stop script if any error
set -e

ID=$(id -u)

if "$ID" != 0; then
    echo -e "\e[32m pls login as a root user \e[0m"
    exit 1
fi


# install nginix
yum install nginx -y >> nginixinstall.log

#download the frontend file from the loation
curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"

#Clear the folder & Deploy the new frontend file in the html folder
cd /usr/share/nginx/html
rm -rf *
unzip /tmp/frontend.zip
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf

#restart nginx
systemctl enable nginx
systemctl start nginx
