#!/usr/bin/env bash

USER=$1;
PASSWORD=$2;

# Default User When Connecting To MariaDB
cat > /root/.my.cnf << EOF
[client]
user = $USER
password = $PASSWORD
host = localhost
EOF

cp /root/.my.cnf /home/vagrant/.my.cnf