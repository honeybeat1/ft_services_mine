# alpine OS로 구현
FROM alpine:3.12
# alpine에서는 apk 패키지 사용
RUN apk update
RUN apk add --no-cache nginx
RUN adduser -D -g 'www' www
RUN mkdir /www
RUN chown -R www:www /var/lib/nginx
RUN chown -R www:www /www

RUN mkdir -p /run/nginx
COPY nginx.conf /etc/nginx/nginx.conf
COPY index.html /www/index.html

# SSL (SSH pass)
RUN apk add --no-cache openssl
RUN mkdir -p /etc/nginx/ssl
RUN openssl req -x509 -nodes -days 365 -subj "/C=KR/ST=Korea/L=Seoul/O=innoaca/OU=42seoul/CN=dachung" -newkey rsa:2048 -keyout /etc/ssl/nginx-selfsigned.key -out /etc/ssl/nginx-selfsigned.crt; 

# 22 port 쓸 필요 없는데 해줘야 하나?
# 22 port is being already used in MAC
EXPOSE 80 443 30022

# daemon off 해주는 부분
COPY init.sh ./init.sh
CMD sh ./init.sh