source common.sh
component=mongo


PRINT Copy repo file 
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOG_FILE
STAT $?

PRINT Installing Mongo
dnf install mongodb-org -y &>>$LOG_FILE
STAT $?


PRINT Updating Config file 
sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>$LOG_FILE
STAT $?

PRINT Start Mongodb service
systemctl enable mongod &>>$LOG_FILE
systemctl restart mongod &>>$LOG_FILE
STAT $?
