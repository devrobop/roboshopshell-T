source common.sh
component=frontend
app_path=/usr/share/nginx/html/    


PRINT Nginx Disable Default version
dnf module disable nginx -y &>>$LOG_FILE
STAT $?

PRINT Enable nginx module 1.24
dnf module enable nginx:1.24 -y &>>$LOG_FILE
STAT $?

PRINT Install Nginx
dnf install nginx -y &>>$LOG_FILE
STAT $?

PRINT COPY Nginx config file 
cp nginx.conf /etc/nginx/nginx.conf &>>$LOG_FILE
STAT $?

APP_PREREQ

PRINT start Nginx service
systemctl enable nginx &>>$LOG_FILE
systemctl restart nginx &>>$LOG_FILE
STAT $?