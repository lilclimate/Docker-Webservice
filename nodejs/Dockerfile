FROM z/centos6.6

MAINTAINER Z 

ENV NVM_VERSION 0.32.1
ENV NODE_VERSION 4.6.2

ENV NVM_DIR /data/nvm$NVM_VERSION

RUN cd /tmp && \
curl -o- https://raw.githubusercontent.com/creationix/nvm/v$NVM_VERSION/install.sh | bash

RUN [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" && \
nvm install $NODE_VERSION && \
nvm alias default $NODE_VERSION && \
npm install -g cnpm --registry=https://registry.npm.taobao.org

ENV NODE_PATH $NVM_DIR/versions/node/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

RUN cnpm install -g pm2 supervisor node-inspector

RUN cnpm install redis socket.io express

WORKDIR /data/www/nodejs/

CMD ["/data/sh/run/nodejs.sh"]

EXPOSE 3000