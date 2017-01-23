FROM z/centos6.6

MAINTAINER Z 

ADD opt/xunsearch-full-1.4.10.tar.bz2 /opt/

RUN cd /opt/xunsearch-full-1.4.10 && \
sh setup.sh --prefix=/data/xunsearch1.4.10

RUN cd /data/xunsearch1.4.10/ && \
echo "#!/bin/sh" > bin/xs-docker.sh && \
echo "rm -f tmp/pid.*" >> bin/xs-docker.sh && \
echo "echo -n > tmp/docker.log" >> bin/xs-docker.sh && \
echo "/data/xunsearch1.4.10/bin/xs-indexd -l tmp/docker.log -k start" >> bin/xs-docker.sh && \
echo "sleep 1" >> bin/xs-docker.sh && \
echo "/data/xunsearch1.4.10/bin/xs-searchd -l tmp/docker.log -k start" >> bin/xs-docker.sh && \
echo "sleep 1" >> bin/xs-docker.sh && \
echo "tail -f tmp/docker.log" >> bin/xs-docker.sh && \
chmod +x bin/xs-docker.sh

RUN rm -rf /opt/*

CMD ["/data/sh/run/xs.sh"]

EXPOSE 8383
EXPOSE 8384
