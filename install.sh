#!/bin/bash
#Replace \n with \n to fix carriage return issue in notepad++
#Use this values in the microweber installation
#=================================================
#Make this file executable:
#sudo chmod +x install.sh
#=================================================
MYSQL_USER="cocktailMachine"
MYSQL_USER_PASSWORD="iLoveCocktails"
MYSQL_DB_NAME="CocktailMachine"
MYSQL_ROOT_PASSWORD="root"
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root."
   exit 1
fi
if [ -a log.out ];then
	sudo rm log.out | tee -a log.out
fi
sudo touch log.out | tee -a log.out
echo "===========Change Hostname===========" | tee -a log.out
sudo hostnamectl set-hostname cocktail-machine | tee -a log.out
echo "===========Update packet list===========" | tee -a log.out
sudo apt-get update -y | tee -a log.out
echo "===========Upgrade packet list===========" | tee -a log.out
sudo apt-get upgrade -y | tee -a log.out
echo "===========Install mariadb (mysql)==========" | tee -a log.out
sudo apt-get install mariadb-server -y | tee -a log.out
echo "===========Starting MariaDB==========" | tee -a log.out
sudo systemctl start mariadb | tee -a log.out
echo "===========Configure MariaDB==========" | tee -a log.out
sudo mysql -uroot -e "UPDATE mysql.user SET Password=PASSWORD('$MYSQL_ROOT_PASSWORD') WHERE User='root';" | tee -a log.out
sudo mysql -uroot -e "DELETE FROM mysql.user WHERE User='';" | tee -a log.out
sudo mysql -uroot -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');" | tee -a log.out
sudo mysql -uroot -e "CREATE DATABASE $MYSQL_DB_NAME;" | tee -a log.out
sudo mysql -uroot -e "CREATE USER '$MYSQL_USER'@'localhost' IDENTIFIED BY '$MYSQL_USER_PASSWORD';" | tee -a log.out
sudo mysql -uroot -e "GRANT ALL ON $MYSQL_DB_NAME.* TO '$MYSQL_USER'@'localhost' IDENTIFIED BY '$MYSQL_USER_PASSWORD' WITH GRANT OPTION;" | tee -a log.out
sudo mysql -uroot -e "FLUSH PRIVILEGES;"| tee -a log.out
echo "===========Load Databases==========" | tee -a log.out
sudo mysql -h "localhost" -u "root"  "$MYSQL_DB_NAME" < "mysql/create.sql"
sudo mysql -h "localhost" -u "root"  "$MYSQL_DB_NAME" < "mysql/insert.sql"
echo "===========Install python==========" | tee -a log.out
sudo apt-get install python -y | tee -a log.out
sudo apt-get install python-mysql.connector | tee -a log.out
sudo pip install Adafruit_WS2801 | tee -a log.out
echo "===========Finished Installation===========" | tee -a log.out