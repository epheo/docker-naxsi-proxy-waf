FROM centos
MAINTAINER Thibaut Lapierre <root@epheo.eu>

#Variables
ENV NGINX_VERSION 1.7.0
ENV PROXY_REDIRECT_IP 192.168.7.10

#Install dependencies
RUN yum install -y wget tar pcre pcre-devel openssl-devel gcc unzip

# Nginx
RUN cd /usr/src/ && wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && tar xf nginx-${NGINX_VERSION}.tar.gz && rm -f nginx-${NGINX_VERSION}.tar.gz
# Naxsi
RUN cd /usr/src/ && wget https://github.com/nbs-system/naxsi/archive/master.zip && unzip master.zip && rm master.zip

# Compiling nginx with Naxsi
RUN cd /usr/src/nginx-${NGINX_VERSION} && ./configure \
         --conf-path=/etc/nginx/nginx.conf \
         --add-module=../naxsi-master/naxsi_src/ \
         --error-log-path=/var/log/nginx/error.log \
         --http-client-body-temp-path=/var/lib/nginx/body \
         --http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
         --http-log-path=/var/log/nginx/access.log \
         --http-proxy-temp-path=/var/lib/nginx/proxy \
         --lock-path=/var/lock/nginx.lock \
         --pid-path=/var/run/nginx.pid \
         --with-http_ssl_module \
         --without-mail_pop3_module \
         --without-mail_smtp_module \
         --without-mail_imap_module \
         --without-http_uwsgi_module \
         --without-http_scgi_module \
         --with-http_gzip_static_module \
         --with-ipv6 --prefix=/usr

RUN cd /usr/src/nginx-${NGINX_VERSION} && make && make install

ADD nginx/nginx.conf /etc/nginx/nginx.conf
ADD nginx/naxsi.rules /etc/nginx/naxsi.rules
ADD nginx/naxsi_core.rules /etc/nginx/naxsi_core.rules
ADD nginx/localhost.conf /etc/nginx/localhost.conf

RUN touch /etc/nginx/naxsi_all.rules && mkdir /var/lib/nginx

#HomeMade template :)
RUN sed -i s/'<proxy_redirect_ip>'/${PROXY_REDIRECT_IP}/g /etc/nginx/localhost.conf

EXPOSE 80
CMD ["nginx"]