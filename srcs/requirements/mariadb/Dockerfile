FROM debian:buster

RUN apt-get update && apt-get install -y mariadb-server

# Copy configuration files
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# Copy initialization script
COPY ./tools/init_db.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init_db.sh

EXPOSE 3306

# Start MySQL service
CMD ["sh", "-c", "init_db.sh && mysqld"]