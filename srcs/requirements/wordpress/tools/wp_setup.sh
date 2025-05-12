#!/bin/bash

# Check if WordPress is already installed
if [ ! -f /var/www/html/wp-config.php ]; then
    # Download WordPress
    wp core download --allow-root
    
    # Wait for MariaDB to be ready
    echo "Waiting for MariaDB..."
    while ! mysql -h mariadb -u${MYSQL_USER} -p${MYSQL_PASSWORD} -e "SELECT 1" >/dev/null 2>&1; do
        sleep 5
    done
    echo "MariaDB is ready!"
    
    # Create WordPress configuration
    wp config create --allow-root \
        --dbname=${MYSQL_DATABASE} \
        --dbuser=${MYSQL_USER} \
        --dbpass=${MYSQL_PASSWORD} \
        --dbhost=mariadb
    
    # Install WordPress
    wp core install --allow-root \
        --url=${DOMAIN_NAME} \
        --title=${WP_TITLE} \
        --admin_user=${WP_ADMIN_USER} \
        --admin_password=${WP_ADMIN_PASSWORD} \
        --admin_email=${WP_ADMIN_EMAIL}
    
    # Create an additional user
    wp user create --allow-root \
        ${WP_USER} ${WP_EMAIL} \
        --user_pass=${WP_PASSWORD} \
        --role=author
fi

# Ensure correct permissions
chown -R www-data:www-data /var/www/html

exec "$@"