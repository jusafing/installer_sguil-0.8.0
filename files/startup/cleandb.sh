#!/bin/bash

SCDIR="/nsm/scripts/"
DELDB_SQL="$SCDIR/cleandb.sql"
SGUILDB_SQL="/usr/local/sguil-0.8.0/server/sql_scripts/create_sguildb.sql"
echo -n "[ CLEAN_DATABASE ]  Restarting MYSQL        ... PID " 
for i in `ps aux | grep mysqld  | grep -v grep | awk '{print $2}'`; do kill -9 $i && echo -n "$i "; done && echo "killed OK"
echo    "[ CLEAN_DATABASE ]  Starting Mysqld         ... " && /etc/init.d/mysql start 				   && echo "OK"
echo -n "[ CLEAN_DATABASE ]  Cleaning database       ... " && mysql -u root -pdbroot  < $DELDB_SQL  		   && echo "OK"
echo    "[ CLEAN_DATABASE ]  Creating Sguil DB       ... " && mysql -u sguil -pdbsguil -e "CREATE DATABASE sguildb" && echo "OK"
echo -n "[ CLEAN_DATABASE ]  Loading  script DB      ... " && mysql -u sguil -pdbsguil -D sguildb < $SGUILDB_SQL    && echo "OK"
echo -n "[ CLEAN_DATABASE ]  Adding new sguil user. "
/usr/local/sguil-0.8.0/server/sguild -adduser sguil

