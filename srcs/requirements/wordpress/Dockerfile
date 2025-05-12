FROM debian:buster

# Install required packages
RUN apt-get update && apt-get install -y \
    php7.3-fpm \
    php7.3-mysql \
    php7.3-curl \
    php7.3-gd \
    php7.3-intl \
    php7.3-mbstring \
    php7.3-soap \
    php7.3-xml \
    php7.3-xmlrpc \
    php7.3-zip \
    wget \
    curl \
    mariadb-client

# Configure PHP-FPM to listen on network
RUN mkdir -p /run/php && \
    sed -i 's/listen = \/run\/php\/php7.3-fpm.sock/listen = 9000/g' /etc/php/7.3/fpm/pool.d/www.conf

# Download and install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Create directory for WordPress
RUN mkdir -p /var/www/html
WORKDIR /var/www/html

# Copy WordPress installation script
COPY ./tools/wp_setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/wp_setup.sh

# Expose port 9000
EXPOSE 9000

# Start PHP-FPM and run WordPress setup
CMD ["sh", "-c", "wp_setup.sh && php-fpm7.3 -F"]