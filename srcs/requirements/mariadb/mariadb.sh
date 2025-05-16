#!/bin/sh
set -eu

echo "→ Starting temporary MariaDB server..."
mysqld_safe --datadir=/var/lib/mysql &

sleep 5

echo "→ Waiting for MariaDB to be ready..."
until mysqladmin ping -uroot --silent; do
  sleep 1
done

echo "→ Initializing database and user..."
mysql -uroot -p"${MARIADB_ROOT_PASSWORD}" <<-SQL
  CREATE DATABASE IF NOT EXISTS \`${MARIADB_DATABASE}\`;
  DROP USER IF EXISTS '${MARIADB_USER}'@'%';
  CREATE USER '${MARIADB_USER}'@'%' IDENTIFIED BY '${MARIADB_PASSWORD}';
  GRANT ALL PRIVILEGES ON \`${MARIADB_DATABASE}\`.* TO '${MARIADB_USER}'@'%';
  FLUSH PRIVILEGES;
SQL

echo "→ Shutting down temporary MariaDB..."
mysqladmin -uroot -p"${MARIADB_ROOT_PASSWORD}" shutdown

echo "→ Relaunching MariaDB..."
exec mysqld
