FROM z/centos6.6 

MAINTAINER Z 

ADD opt/nginx-1.11.1.tar.gz /opt/
ADD opt/bundle /opt/nginx-1.11.1/bundle/
ADD opt/echo-nginx-module /opt/nginx-1.11.1/bundle/echo-nginx-module/
ADD opt/LuaJIT-2.1.0-beta2.tar.gz /opt/nginx-1.11.1/bundle/
ADD opt/v0.2.19.tar.gz /opt/nginx-1.11.1/bundle/
ADD opt/v0.3.0.tar.gz /opt/nginx-1.11.1/bundle/
ADD opt/2.3.tar.gz /opt/nginx-1.11.1/bundle/
ADD opt/v0.10.7.tar.gz /opt/nginx-1.11.1/bundle/
ADD nginx.sh /etc/init.d/nginx

RUN yum install -y readline-devel lua-devel
RUN cd /opt/nginx-1.11.1/bundle/LuaJIT-2.1.0-beta2 && \
make clean && make && make install && \
ln -sf luajit-2.1.0-beta2 /usr/local/bin/luajit && \
# tell nginx's build system where to find LuaJIT 2.1:
export LUAJIT_LIB=./lib && \
export LUAJIT_INC=./luajit/include/luajit-2.1


RUN mkdir /var/tmp/nginx/ && \
cd /opt/nginx-1.11.1 && ls -a && \
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
--with-ld-opt="-Wl,-rpath,$LUAJIT_LIB" \
--add-module=/opt/nginx-1.11.1/bundle/echo-nginx-module \
--add-module=/opt/nginx-1.11.1/bundle/ngx_cache_purge-2.3 \
--add-module=/opt/nginx-1.11.1/bundle/nginx_upstream_check_module-0.3.0 \
--add-module=/opt/nginx-1.11.1/bundle/ngx_devel_kit-0.2.19 \
--add-module=/opt/nginx-1.11.1/bundle/lua-nginx-module-0.10.7 \
--with-pcre \
--with-http_image_filter_module && \
make -j2 && make install && \

ln -s /data/nginx/sbin/nginx /usr/sbin/nginx && \

echo "1 0 * * * /data/sh/cut_nginx_logs.sh" >> /var/spool/cron/root && \

chmod +x /etc/init.d/nginx && \

yum clean all && rm -rf /var/cache/yum/*

CMD ["service", "nginx", "start"] # 必须使用双引号

EXPOSE 80 443
