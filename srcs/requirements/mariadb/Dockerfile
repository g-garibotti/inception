FROM debian:bullseye-slim

RUN apt update -y && \
    apt install -y mariadb-server && \
    rm -rf /var/lib/apt/lists/*

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY mariadb.sh /usr/local/bin/mariadb.sh
RUN chmod +x /usr/local/bin/mariadb.sh

ENTRYPOINT ["sh", "/usr/local/bin/mariadb.sh"]


