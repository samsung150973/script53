#!/bin/bash
echo "I am frontend"
COMPONENT=frontend
LOGFILE="install.log"

check (){
if [ $1 -ne 0 ]; 
    then
        echo -e "\e[33m unsuccessful \e[0m"
        exit 2
    else 
        echo -e "\e[33m successful \e[0m"
fi
}

# this command will stop script if any error
set -e

# check if root user. in lunix root user id is 0 "id -u". Assign output to a variable and then check
ID=$(id -u)
    if [ "$ID" -ne 0 ]; 
        then
            echo -e "\e[33m pls login as a root user \e[0m"
            exit 1
    fi

# install nginix
echo -n "installing nginx :"
yum install nginx -y &>> $LOGFILE
check $?


#download the frontend file from the loation
echo -n "Downloading the $COMPONENT component:"
curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"

# check if frontend download successful and print a message
check $?

#Clear the folder & Deploy the new frontend file in the html folder
cd /usr/share/nginx/html
rm -rf * &>> "$COMPONENT.log"
unzip /tmp/$COMPONENT.zip &>> $LOGFILE
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf

#restart nginx
echo -n "restarting Nginix Server :"
systemctl enable nginx &>> "$LOGFILE"
systemctl start nginx &>> "$LOGFILE"
check $?