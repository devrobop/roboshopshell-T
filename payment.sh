source common.sh    
component=payment
app_path=/app

PRINT Installing python 
dnf install python3 gcc python3-devel -y &>>$LOG_FILE
STAT $?

APP_PREREQ
    
PRINT Installing requirements
cd /app 
pip3 install -r requirements.txt &>>$LOG_FILE
STAT $?

SYSTEMD_SETUP

