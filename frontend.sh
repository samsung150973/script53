#!/bin/bash
echo "I am frontend"
logfile = $install.log

Check ()
if [ $? -ne 0 ];
then
    echo -e "\e[33m installation unsuccessful \e[0m"
    exit 2
else 
    echo -e "\e[33m installation successful \e[0m"
fi

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
echo -n "installing nginx :"
yum install nginx -y &>> "$logfile"

# check if nginix installition is successful and print a message
check ()
# if [ $? -ne 0 ];
# then
#     echo -e "\e[33m Nginix installation unsuccessful \e[0m"
#     exit 2
# else 
#     echo -e "\e[33m Nginix installation successful \e[0m"
# fi


#download the frontend file from the loation
echo -n "instaling frontend :"
curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"

# check if frontend download successful and print a message
check()
# if [ $? -ne 0 ];
# then
#     echo -e "\e[33m fronend download unsuccessful \e[0m"
#     exit 3
# else 
#     echo -e "\e[33m frontend installation successful \e[0m"
# fi

#Clear the folder & Deploy the new frontend file in the html folder
cd /usr/share/nginx/html
rm -rf * &>> "$logfile"
unzip /tmp/frontend.zip &>> "$logfile"
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf

#restart nginx
systemctl enable nginx &>> "$logfile"
systemctl start nginx &>> "$logfile"
echo -e "\e[33m Nginix restart successful \e[0m"