FROM z/centos6.6

MAINTAINER Z

ADD opt/openresty-1.11.2.1.tar.gz /opt/
ADD opt/v0.3.0.tar.gz /opt/openresty-1.11.2.1/bundle/
ADD opt/2.3.tar.gz /opt/openresty-1.11.2.1/bundle/
ADD nginx.sh /etc/init.d/nginx
RUN df -h 
RUN yum install -y readline-devel
RUN mkdir /data/log/nginx && \
cd /opt/openresty-1.11.2.1/bundle/LuaJIT-2.1-20160517 && \
make clean && make && make install && \
ln -sf luajit-2.1.0-alpha /usr/local/bin/luajit && \
cd /opt/openresty-1.11.2.1 && \
./configure \
--prefix=/data/openresty \
--with-luajit \
--with-http_realip_module \
--with-pcre \
--add-module=./bundle/ngx_cache_purge-2.3/ \
--add-module=./bundle/nginx_upstream_check_module-0.3.0/ \
--with-http_iconv_module \
--without-http_redis2_module -j2 && \
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