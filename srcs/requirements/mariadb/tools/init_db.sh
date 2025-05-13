#!/bin/bash

# Check if the database directory is initialized
if [ ! -d "/var/lib/mysql/mysql" ]; then
    # Initialize the MariaDB data directory
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    # Start MariaDB temporarily to configure it
    /usr/bin/mysqld_safe --datadir=/var/lib/mysql --skip-networking &
    pid="$!"

    # Wait for MySQL server to start
    for i in {30..0}; do
        if mysqladmin ping >/dev/null 2>&1; then
            break
        fi
        echo "Waiting for database server to start... $i"
        sleep 1
    done

    if [ "$i" = 0 ]; then
        echo >&2 "Error: Database server failed to start"
        exit 1
    fi

    # Execute SQL commands to configure MySQL
    mysql -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"
    mysql -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
    mysql -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';"
    mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
    mysql -e "FLUSH PRIVILEGES;"

    # Shut down the temporary server
    mysqladmin shutdown
fi

# Start MySQL server in the foreground (no &)
exec mysqld --user=mysql --datadir=/var/lib/mysql