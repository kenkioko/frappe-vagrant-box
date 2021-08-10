#!/usr/bin/env bash

DB_ROOT_PWD=$1;
USER=$2;
PASSWORD=$3;

# Set the default password when connecting to mysqld
export MYSQL_PWD=$DB_ROOT_PWD

# Create MariaDB User
mysql --user="root" -e "CREATE USER IF NOT EXISTS '$USER'@'0.0.0.0' IDENTIFIED BY '$PASSWORD';"
mysql --user="root" -e "GRANT ALL ON *.* TO '$USER'@'0.0.0.0' IDENTIFIED BY '$PASSWORD' WITH GRANT OPTION;"
mysql --user="root" -e "GRANT ALL ON *.* TO '$USER'@'%' IDENTIFIED BY '$PASSWORD' WITH GRANT OPTION;"
mysql --user="root" -e "FLUSH PRIVILEGES;"

# Restart MariaDB Service
service mysql restart

# Unset the default password
unset MYSQL_PWD