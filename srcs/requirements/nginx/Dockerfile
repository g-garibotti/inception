FROM debian:bullseye-slim

RUN apt-get update && \
    apt-get install -y nginx openssl curl && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/ssl /var/run/nginx

RUN openssl req -x509 -nodes \
    -out /etc/nginx/ssl/inception.crt \
    -keyout /etc/nginx/ssl/inception.key \
    -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=ggaribot.42.fr/UID=ggaribot"

COPY conf/nginx.conf /etc/nginx/nginx.conf

RUN chmod 755 /var/www/html && \
    chown -R www-data:www-data /var/www/html

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
