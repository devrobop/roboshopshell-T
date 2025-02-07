source common.sh
component=mysql


PRINT Install mysql
dnf install mysql-server -y &>>$LOG_FILE
STAT $?

PRINT Start  mysql service
systemctl enable mysqld &>>$LOG_FILE
systemctl restart mysqld  &>>$LOG_FILE
STAT $?


PRINT Set rootpassword for user
mysql_secure_installation --set-root-pass RoboShop@1 &>>$LOG_FILE
STAT $?
