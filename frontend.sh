#!/bin/bash
echo "I am frontend"

# this command will stop script if any error
set -e

# check if the executed as a root user. in lunix root user id is 0 "id -u". Assign output to a variable and then check
ID=$(id -u)
if [ "$ID" -ne 0 ]; 
then
    echo -e "\e[33m pls login as a root user \e[0m"
    exit 1
fi

# install nginix
echo " installing nginx"
yum install nginx -y &>> /temp/nginixinstall.log

# check if nginix installition is successful and print a message
if [ $? -ne 0 ];
then
    echo -e "\e[33m Nginix installation successful \e[0m"
fi


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
