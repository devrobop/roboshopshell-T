source common.sh
component=rabbitmq


PRINT Copying repo file
cp  rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo &>>$LOG_FILE
STAT $?

PRINT Installing Rabbitmq server
dnf install rabbitmq-server -y &>>$LOG_FILE
STAT $?

PRINT Starting Rabbitmq server
systemctl enable rabbitmq-server &>>$LOG_FILE
systemctl start rabbitmq-server &>>$LOG_FILE
STAT $?

PRINT Adding user 
rabbitmqctl add_user roboshop roboshop123 &>>$LOG_FILE
STAT $?


PRINT Updating required permissions
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOG_FILE
STAT $?
