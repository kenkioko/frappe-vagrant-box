#!/usr/bin/env bash

DB=$1;
mysql=$(pidof mysqld)
mariadb=$(pidof mariadbd)

if [ -z "$mysql" ] && [ -z "$mariadb" ]
then
      # Skip Creating MariaDB database
      echo "We didn't find a PID for mariadb, skipping \$DB creation"
else
      mysql -e "CREATE DATABASE IF NOT EXISTS \`$DB\` DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_unicode_ci";
fi
