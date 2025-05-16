FROM debian:bullseye

RUN apt-get update && apt-get install -y nginx openssl

# SSL certificate pour secur
RUN mkdir -p /etc/nginx/ssl
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=ggaribot.42.fr"

# chope conf prep
COPY ./conf/nginx.conf /etc/nginx/conf.d/default.conf

# port 443 for HTTPS
EXPOSE 443

# Start cmd
CMD ["nginx", "-g", "daemon off;"]