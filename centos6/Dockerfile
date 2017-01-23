FROM centos:6.6

MAINTAINER Z 

RUN yum install -y wget vim crontabs sudo curl telnet ntp man zip unzip tar && \

groupadd www-data && \
useradd -g www-data www-data -s /sbin/nologin && \
usermod -u 1000 www-data && usermod -G ftp www-data && \
mkdir /data/ /data/www/ /data/static/ /data/sh/ /data/log/ &&\
echo -e '*/1 * * * * chown -R www-data:www-data /data/www/;chown -R www-data:www-data /data/static/;' >> /var/spool/cron/root && \

rm -rf /var/lib/yum/history/* && rpm --import /etc/pki/rpm-gpg/RPM* && \
cd /etc/yum.repos.d && mv CentOS-Base.repo CentOS-Base.repo.backup && \
wget http://mirrors.163.com/.help/CentOS6-Base-163.repo && mv CentOS6-Base-163.repo CentOS-Base.repo && \
rpm -Uvh http://ftp.sjtu.edu.cn/fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm && \
yum clean all && yum makecache && \

cd ~ && \
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
export LANG="en_US.UTF-8" && \
echo -e 'LANG="en_US.UTF-8"\nSYSFONT="latarcyrheb-sun16"' >> /etc/sysconfig/i18n && \
source /etc/sysconfig/i18n && \

echo -e 'set nu' /etc/vimrc && \ 

echo -e "alias vi='vim'\nalias ll='ls -al' \n\
alias la='ls -a' \n\
alias lw='ls -al | wc -l' \n\n\
alias cp='cp -i' \n\
alias mv='mv -i' \n\
alias rm='rm -i' \n\
alias ..='cd ..' \n\
alias hclear='history -c; rm -f ~/.zsh_history  ~/.bash_history;' \n\n\
alias findd='find -type d -name' \n\
alias findf='find -type f -name' \n\n\
alias vi='sudo vim' \n\
alias grep='grep --color=auto' \n\
alias cmount='mount | column -t' \n\
alias meminfo='free -m -l -t' \n\n\
alias gz='tar -zxvf'" >> ~/.bashrc && \

source ~/.bashrc && \

yum install -y sysstat gdb gcc gcc-c++ gcc-gfortran make cmake autoconf automake libtool libtool-libs glibc glibc-devel openssl openssl-devel zlib zlib-devel pcre pcre-devel gd gd-devel libiconv libmcrypt libmcrypt-devel mcrypt libcurl libcurl-devel libpng libpng-devel libjpeg libjpeg-devel libevent libevent-devel mlocate libxslt libxml2 libxml2-devel libxslt-devel rsync && \
updatedb && \

yum clean all && rm -rf /var/cache/yum/*

