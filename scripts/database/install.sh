#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive
DB_ROOT_PWD=$1;

# Install Software Properties
apt-get install -y software-properties-common

# Add MariaDB PPA
apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8
add-apt-repository 'deb [arch=amd64] http://ftp.ubuntu-tw.org/mirror/mariadb/repo/10.3/ubuntu bionic main'

# Without 'root' password prompt
debconf-set-selections <<< "mariadb-server mysql-server/data-dir select ''"
debconf-set-selections <<< "mariadb-server mysql-server/root_password password $DB_ROOT_PWD"
debconf-set-selections <<< "mariadb-server mysql-server/root_password_again password $DB_ROOT_PWD"
mkdir  /etc/mysql
touch /etc/mysql/debian.cnf

# Install MariaDB
apt-get update
apt-get install -y mariadb-server-10.3 mariadb-client-10.3 libmysqlclient-dev

# Config files
echo >> /etc/mysql/my.cnf
cat /home/vagrant/mariadb/mariadb.cnf >> /etc/mysql/my.cnf

# Configure Maria Remote Access and ignore db dirs
sed -i "s/bind-address            = 127.0.0.1/bind-address            = 0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf
cat > /etc/mysql/mariadb.conf.d/50-server.cnf << EOF
[mysqld]
bind-address = 0.0.0.0
ignore-db-dir = lost+found
#general_log
#general_log_file=/var/log/mysql/mariadb.log
EOF

# Set the default password when connecting to mysqld
export MYSQL_PWD=$DB_ROOT_PWD

# 'root@'0.0.0.0' user
mysql --user="root" -e "GRANT ALL ON *.* TO root@'0.0.0.0' IDENTIFIED BY '$DB_ROOT_PWD' WITH GRANT OPTION;"

# Restart MariaDB Service
service mysql restart

# Upgrade 'root' user
mysql_upgrade --user="root" --verbose --force

# Restart MariaDB Service
service mysql restart

# Unset env variables
unset MYSQL_PWD
unset DEBIAN_FRONTEND