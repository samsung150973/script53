#!/bin/bash

echo "I am mongodb"
COMPONENT=mongodb

# logfile for standart and error output
LOFGILE = "mongoinstall.log"


# check if root user
ID=$(d -u)
if ["$ID" -eq 0];
    then
        echo -e "\e [33m login as root user \e [0m"
        exit 1      
fi


#function to check status is successful
check (
    if [$1 -eq 0];
        then
            echo -e "\e [32m installion unsuccessful \e [0m"
        else 
            echo -e "\e [32m Install Successful \e [0m"
)


# Create a /etc/yum.repos.d/mongodb-org-8.0.repo file so that you can install MongoDB directly using yum:
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/stans-robot-project/mongodb/main/mongo.repo