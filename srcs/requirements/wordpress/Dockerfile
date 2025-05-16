FROM debian:bullseye-slim
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      ca-certificates curl dos2unix \
      php7.4 php7.4-cli php7.4-fpm php7.4-mysql \
      mariadb-client \
 && rm -rf /var/lib/apt/lists/*

# PHP-FPM
RUN mkdir -p /run/php && chown www-data:www-data /run/php
COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

# install auto
COPY conf/wordpress.sh /usr/local/bin/entrypoint.sh
RUN dos2unix /usr/local/bin/entrypoint.sh && chmod +x /usr/local/bin/entrypoint.sh

# WP-CLI
RUN curl -fsSL https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    -o /usr/local/bin/wp \
 && chmod +x /usr/local/bin/wp

RUN echo "clear_env = no" >> /etc/php/7.4/fpm/php-fpm.conf

WORKDIR /var/www/html/wordpress
EXPOSE 9000

ENTRYPOINT ["sh", "/usr/local/bin/entrypoint.sh"]
