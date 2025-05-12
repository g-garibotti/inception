#!/bin/bash

# Check if the database directory is initialized
if [ ! -d "/var/lib/mysql/mysql" ]; then
    # Initialize the MariaDB data directory
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# Start MySQL in the background
mysqld_safe --datadir=/var/lib/mysql &

# Wait for the server to start
until mysqladmin ping -h localhost --silent; do
    sleep 1
done

# Check if the wordpress database exists
if ! mysql -e "USE ${MYSQL_DATABASE}" 2>/dev/null; then
    # Create database and users
    mysql -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"
    mysql -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
    mysql -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';"
    mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
    mysql -e "FLUSH PRIVILEGES;"
fi

# Stop MySQL safely
mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown

# Start MySQL in the foreground
exec mysqld --datadir=/var/lib/mysql