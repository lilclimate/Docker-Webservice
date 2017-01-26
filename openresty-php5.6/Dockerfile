FROM z/openresty1.11.2.1

MAINTAINER Z

ADD opt/php-5.6.23.tar.gz /opt/
ADD opt/igbinary-1.2.1.tgz /opt/
ADD opt/yaf-2.3.5.tgz /opt/
ADD opt/swoole-1.8.7.tgz /opt/
ADD opt/cphalcon /opt/cphalcon
ADD opt/phpredis /opt/phpredis
ADD php-fpm.sh /etc/init.d/php-fpm
ADD opt/xdebug-2.4.0 /opt/xdebug-2.4.0
ADD opt/beanstalkd /opt/beanstalkd

RUN yum install -y libicu-devel && \
cd /opt/php-5.6.23 && \
./configure \
--prefix=/data/php5.6/ \
--with-fpm-user=www-data \
--with-fpm-group=www-data \
--with-config-file-path=/data/php5.6/etc \
--with-config-file-scan-dir=/data/php5.6/php.d \
--with-mysql \
--with-mysqli \
--with-pdo-mysql \
--with-zlib \
--with-curl \
--with-gd \
--with-openssl \
--with-mhash \
--with-mcrypt \
--with-xmlrpc \
--with-pcre-dir \
--with-freetype-dir \
--with-jpeg-dir \
--with-png-dir \
--with-zlib-dir \
--with-libxml-dir \
--with-iconv-dir \
--with-gettext \
--with-iconv \
--without-sqlite3 \
--without-pdo-sqlite \
--enable-fpm \
--enable-mbstring \
--enable-zip \
--enable-soap \
--enable-opcache \
--enable-xml \
--enable-sockets \
--enable-sysvshm \
--enable-sysvsem \
--enable-shmop \
--enable-bcmath \
--enable-inline-optimization \
--enable-gd-native-ttf \
--enable-mbregex \
--enable-pcntl \
--enable-wddx \
--enable-calendar \
--enable-exif \
--enable-intl \
--disable-debug \
--disable-rpath \
--disable-ipv6 \
--disable-maintainer-zts && \
make -j2 && make install && \

ln -s /data/php5.6/bin/php /usr/local/bin/php && \
ln -s /data/php5.6/bin/phpize /usr/local/bin/phpize && \
cp /data/php5.6/etc/php-fpm.conf.default /data/php5.6/etc/php-fpm.conf && \
cp /opt/php-5.6.23/php.ini-production /data/php5.6/etc/php.ini && \
echo -e '\n' >> /data/php5.6/etc/php.ini

RUN cd /opt/yaf-2.3.5 && \
phpize && \
./configure --with-php-config=/data/php5.6/bin/php-config && \
make && make install && \
echo -e '\nextension=yaf.so' >> /data/php5.6/etc/php.ini && \

cd /opt/swoole-1.8.7 && \
phpize && \
./configure --with-php-config=/data/php5.6/bin/php-config && \
make && make install && \
echo -e '\nextension=swoole.so' >> /data/php5.6/etc/php.ini && \

cd /opt/igbinary-1.2.1 && \
phpize && \
./configure --with-php-config=/data/php5.6/bin/php-config && \
make && make install && \
echo -e '\nextension=igbinary.so' >> /data/php5.6/etc/php.ini && \

cd /opt/phpredis && \
phpize && \
./configure --enable-redis-igbinary --with-php-config=/data/php5.6/bin/php-config && \
make && make install && \
echo -e '\nextension=redis.so' >> /data/php5.6/etc/php.ini

RUN cd /opt/xdebug-2.4.0 &&\
phpize && \
./configure --with-php-config=/data/php5.6/bin/php-config && make -j2 && \
cp modules/xdebug.so /data/php5.6/lib/php/extensions/no-debug-non-zts-20131226 && \
chmod +x /etc/init.d/php-fpm && \
chkconfig --add php-fpm

RUN curl -sS https://getcomposer.org/installer | php && \
mv composer.phar /usr/local/bin/composer
RUN composer global require "phpunit/phpunit=5.5.*" && \
composer global require "phpunit/php-invoker=1.1.*" && \
composer global require "phpunit/dbunit >=1.2"

RUN yum install -y git luarocks && \
luarocks install lua-resty-repl

CMD ["/data/sh/run/nginx-php.sh"]
