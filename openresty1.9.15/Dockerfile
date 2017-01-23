FROM z/centos6.6

MAINTAINER Z

ADD opt/openresty-1.9.15.1.tar.gz /opt/
ADD nginx.sh /etc/init.d/nginx

RUN yum install -y readline-devel && \
mkdir /data/log/nginx && \
cd /opt/openresty-1.9.15.1 && \
./configure \
--prefix=/data/openresty \
--with-luajit \
--with-http_realip_module \
--with-http_iconv_module \
--without-http_redis2_module && \
make && make install && \
mkdir -p /data/openresty/nginx/lua && \
usermod -u 1000 www-data && usermod -G ftp www-data && \
echo -e '*/1 * * * * chown -R www-data:www-data /data/openresty/;' >> /var/spool/cron/root


RUN chmod +x /etc/init.d/nginx && \
chkconfig --add nginx && \

ln -s /data/openresty/nginx/sbin/nginx /usr/sbin/nginx && \

yum clean all && rm -rf /var/cache/yum/*
RUN yum install -y redis mysql
RUN yum install -y libuuid-devel

CMD ["service", "nginx", "start"]
