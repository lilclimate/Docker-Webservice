FROM z/centos6.6 

MAINTAINER lizhe

ADD opt/nginx-1.11.1.tar.gz /opt/
ADD nginx.sh /etc/init.d/nginx

RUN mkdir /var/tmp/nginx/ && \
cd /opt/nginx-1.11.1 && \
./configure \
--user=www-data \
--group=www-data \
--prefix=/data/nginx \
--sbin-path=/data/nginx/sbin/nginx \
--conf-path=/data/nginx/conf/nginx.conf \
--error-log-path=/data/log/nginx/error.log \
--http-log-path=/data/log/nginx/access.log \
--pid-path=/var/run/nginx/nginx.pid \
--lock-path=/var/lock/nginx.lock \
--http-client-body-temp-path=/var/tmp/nginx/client/ \
--http-proxy-temp-path=/var/tmp/nginx/proxy/ \
--http-fastcgi-temp-path=/var/tmp/nginx/fcgi/ \
--http-uwsgi-temp-path=/var/tmp/nginx/uwsgi \
--http-scgi-temp-path=/var/tmp/nginx/scgi \
--with-http_stub_status_module \
--with-http_ssl_module \
--with-http_flv_module \
--with-http_gzip_static_module \
--with-file-aio \
--with-http_realip_module \
--with-http_image_filter_module \
--with-pcre && \
make && make install && \

ln -s /data/nginx/sbin/nginx /usr/sbin/nginx && \

echo "1 0 * * * /data/sh/cut_nginx_logs.sh" >> /var/spool/cron/root && \

chmod +x /etc/init.d/nginx && \

yum clean all && rm -rf /var/cache/yum/*

CMD ["service", "nginx", "start"]

EXPOSE 80 443
