source common.sh
component=redis


PRINT Disable previous content
dnf module disable redis -y &>>$LOG_FILE
STAT $?

PRINT Enabling version 7
dnf module enable redis:7 -y &>>$LOG_FILE
STAT $?

PRINT Install redis
dnf install redis -y &>>$LOG_FILE
STAT $?

PRINT Updating Config file 
sed -i '/^bind/ s/127.0.0.1/0.0.0.0/' /etc/redis/redis.conf  &>>$LOG_FILE
sed -i '/protected-mode/ c protected-mode no' /etc/redis/redis.conf &>>$LOG_FILE
STAT $?

PRINT Starting redis
systemctl enable redis &>>$LOG_FILE
systemctl restart redis &>>$LOG_FILE
STAT $?