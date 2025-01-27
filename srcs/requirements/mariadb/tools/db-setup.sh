#!/bin/bash

DB_PATH="/var/lib/mysql/$DB_WP_NAME"

if [ -d "$DB_PATH" ]; then
	echo "$DB_WP_NAME database is already created"
else
	echo "starting mariadb"
	service mariadb start

	echo "remove anonymous users"
	mariadb -e "DROP USER IF EXISTS ''@'localhost'"

	echo "remove demo database test"
	mariadb -e "DROP DATABASE IF EXISTS test"

	echo "create database $DB_WP_NAME"
	mariadb -e "CREATE DATABASE IF NOT EXISTS $DB_WP_NAME"

	echo "create database user $DB_USER"
	mariadb -e "CREATE USER '$DB_USER'@'%' IDENTIFIED BY '$DB_USER_PASSWORD'"

	echo "pass database $DB_WP_NAME privileges to $DB_USER"
	mariadb -e "GRANT ALL PRIVILEGES ON $DB_WP_NAME.* to '$DB_USER'@'%'"

	echo "add a password to root user"
	mariadb -u root -p$DB_ROOT_PASSWORD -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASSWORD';FLUSH PRIVILEGES"

	echo "stopping mariadb"
	mariadb-admin -u root -p$DB_ROOT_PASSWORD -P 3306 shutdown
fi

echo "end of script"
