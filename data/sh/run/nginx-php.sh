#! /bin/sh
cp /data/opt/re.lua /data/openresty/lualib/ngx/
cp /data/opt/regex.lua /data/openresty/lualib/resty/core/
cp -r /data/opt/lua-resty-limit-traffic /data/openresty/lualib/lua-resty-limit-traffic
cp -r /data/opt/lua-resty-cookie /data/openresty/lualib/lua-resty-cookie
cp -r /data/opt/lua-resty-test/lib/resty/iresty_test.lua /data/openresty/lualib/resty/
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:~/.composer/vendor/bin"
ln -s ~/.composer/vendor/bin/phpunit /usr/local/bin/phpunit
cd /opt/beanstalkd && make && mkdir -p /usr/local/beanstalkd/bin
cp beanstalkd /usr/local/beanstalkd/bin
ln -sv /usr/local/beanstalkd/bin/beanstalkd /usr/local/bin/
beanstalkd -l 127.0.0.1 -p 11300&
service php-fpm start
service nginx start

cd /
touch loop.php
ls ./

tail -f ./loop.php
