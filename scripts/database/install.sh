#!/usr/bin/env bash

DB_ROOT_PWD=$1;

# Install Software Properties
apt-get install -y software-properties-common

# Add MariaDB PPA
apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8
add-apt-repository 'deb [arch=amd64] http://ftp.ubuntu-tw.org/mirror/mariadb/repo/10.3/ubuntu bionic main'

# Without 'root' password prompt
debconf-set-selections <<< "mariadb-server mysql-server/data-dir select ''"
debconf-set-selections <<< "mariadb-server mysql-server/root_password password $DB"
debconf-set-selections <<< "mariadb-server mysql-server/root_password_again password $DB"
mkdir  /etc/mysql
touch /etc/mysql/debian.cnf

# Install MariaDB
apt-get update
apt-get install -y mariadb-server-10.3 libmysqlclient-dev

# Config files
cat /home/vagrant/mariadb.cnf >> /etc/mysql/my.cnf

# Restart MariaDB Service
service mysql restart
