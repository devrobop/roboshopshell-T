LOG_FILE=/tmp/roboshop.log
rm -f LOG_FILE
code_dir=$(pwd)

PRINT() {
  echo &>>$LOG_FILE 
  echo &>>$LOG_FILE 
  echo "############################## $* #################################" &>>$LOG_FILE 
  echo $* 
}

STAT() {
  if [ $1 -eq 0 ]; then
    echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[31mFAILURE\e[0m"
    echo 
    echo "Refer the log file for more information : File path : ${LOG_FILE}"
    exit $1
  fi
}
APP_PREREQ() {
  
  PRINT Adding user 
  if [ $? -ne 0 ]; then 
    useradd roboshop &>>$LOG_FILE
  fi   
  STAT $?   

  PRINT Remove old content
  rm -rf ${app_path}  &>>$LOG_FILE
  STAT $?

  PRINT Create app directory 
  mkdir ${app_path} &>>$LOG_FILE
  STAT $?


  PRINT Downloading Application content 
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}-v3.zip &>>$LOG_FILE
  STAT $?

  PRINT Extract Application content
  cd ${app_path} &>>$LOG_FILE
  unzip /tmp/${component}.zip &>>$LOG_FILE
  STAT $?


}

SYSTEMD_SETUP() {
  PRINT Copy Service file
  cp ${code_dir}/${component}.service /etc/systemd/system/${component}.service &>>$LOG_FILE
  STAT $?    
       
  PRINT Start service
  systemctl daemon-reload &>>$LOG_FILE   
  systemctl enable ${component} &>>$LOG_FILE   
  systemctl restart ${component} &>>$LOG_FILE  
  STAT $?   
}


NODEJS() {
  PRINT Disable NodeJS Default Version    
  dnf module disable nodejs -y &>>$LOG_FILE 
  STAT $?


  PRINT Enable NodeJs 20 Version 
  dnf module enable nodejs:20 -y &>>$LOG_FILE   
  STAT $?


  PRINT Installing Nginx
  dnf install nodejs -y &>>$LOG_FILE   
  STAT $?  


 
     
  APP_PREREQ

  PRINT Download  NodeJS dependencies
  npm install &>>$LOG_FILE   
  STAT $? 
    
  SYSTEMD_SETUP
  SCHEMA_SETUP  
}


JAVA() {
    
  PRINT Install maven and Java
  dnf install maven -y &>>LOG_FILE
  STAT $?

  APP_PREREQ

  PRINT Download dependencies
  mvn clean package &>>LOG_FILE
  mv target/shipping-1.0.jar shipping.jar  &>>LOG_FILE
  STAT $?
     
  SCHEMA_SETUP
  SYSTEMD_SETUP
}

SCHEMA_SETUP(){
       
  if [ "$schema_setup" == "mongo" ]  ;then

    PRINT Copy Repo file 
    cp ${code_dir}/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOG_FILE  
    STAT $?    
  
    PRINT Install Mongo Client 
    dnf install mongodb-mongosh -y &>>$LOG_FILE
    STAT $?   

    PRINT load Masterdata
    mongosh --host mongo.dev.devrobo.online </app/db/master-data.js &>>$LOG_FILE
    STAT $?
  fi
  if [ "$schema_setup" == "mysql" ] ; then   
    PRINT Install Mysql Client 
    dnf install mysql -y &>>$LOG_FILE
    STAT $?   

    PRINT load Schema
    mysql -h mysql.dev.devrobo.online -uroot -pRoboShop@1 < /app/db/schema.sql &>>$LOG_FILE
    STAT $?


    PRINT load Master data
    mysql -h mysql.dev.devrobo.online -uroot -pRoboShop@1 < /app/db/master-data.sql &>>$LOG_FILE
    STAT $?

    PRINT create app users 
    mysql -h mysql.dev.devrobo.online -uroot -pRoboShop@1 < /app/db/app-user.sql &>>$LOG_FILE
    STAT $?
  fi 
}
