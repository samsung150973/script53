#!/bin/bash

echo "I am mongodb"
COMPONENT=mongo

#error handling
set -e

# logfile for standart and error output
LOFGILE="mongoinstall.log"


# check if root user
ID=$(id -u)
if [ "$ID" -ne 0 ];
    then
        echo -e "\e[33m login as root user \e[0m"
        exit 1      
fi


#function to check status is successful
check () {
    if [ $1 -ne 0 ];
        then
            echo -e "\e[32m installion Unsuccessful \e[0m"
        else 
            echo -e "\e[32m Install Successful \e[0m"
    fi
}


# Create a /etc/yum.repos.d/mongodb-org-8.0.repo file so that you can install MongoDB directly using yum:
curl -s -o /etc/yum.repos.d/mongodb.repo https://github.com/samsung150973/script53/blob/main/Repository/mongo.repo

# install mongodB and start the service
echo -n "installing mongodb"
yum install -y mongodb-org &>> $LOGFILE
systemctl enable mongod
systemctl start mongod
check $?

#search and update Listen IP address from 127.0.0.1 to 0.0.0.0 in the mongod config file, so that MongoDB can be accessed by other services.
echo -n "updating ip address of port"
sed -i -e 's/127.0.0.0/0.0.0.0'  /etc/mongod.conf
check $?

# systemctl deamon reload and restart mongod
systemctl daemon-reload 
systemctl restart mongod
check $?

#Every Database needs the schema to be loaded for the application to work. `Download the schema and inject it`

curl -s -L -o /tmp/mongodb.zip "https://github.com/stans-robot-project/mongodb/archive/main.zip"
cd /tmp
unzip -o mongodb.zip
cd mongodb-main
mongo < catalogue.js
mongo < users.js
check $?
