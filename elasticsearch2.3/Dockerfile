FROM z/centos6.6

MAINTAINER Z 

ADD opt/elasticsearch-2.3.0.zip /opt/
ADD opt/apache-maven-3.3.9-bin.tar.gz /opt/
ADD opt/elasticsearch-river-jdbc-2.3.0.zip /opt/

RUN yum install -y java-1.7.0-openjdk java-1.7.0-openjdk-devel && \
yum upgrade -y nss && \
mv /opt/apache-maven-3.3.9 /usr/local/maven && \
export M2_HOME=/usr/local/maven && \
echo -e "\nexport M2_HOME=/usr/local/maven\nexport PATH=$PATH:$M2_HOME/bin" >> ~/.bashrc && \
source ~/.bashrc

RUN cd /opt/ && \
unzip elasticsearch-2.3.0.zip && \
mv /opt/elasticsearch-2.3.0/ /data/elasticsearch2.3 && \
cd /data && \
chown -R www-data:www-data elasticsearch2.3 && \
chmod +x /data/elasticsearch2.3/bin/elasticsearch && \
/data/elasticsearch2.3/bin/plugin install mobz/elasticsearch-head && \
echo -e "\nnetwork.bind_host: "0.0.0.0"\nnetwork.publish_host: _non_loopback:ipv4_" >> /data/elasticsearch2.3/config/elasticsearch.yml

RUN cd /opt/ && \
wget https://github.com/medcl/elasticsearch-analysis-ik/archive/v1.9.0.zip && \
unzip v1.9.0.zip && \
cd elasticsearch-analysis-ik-1.9.0 && \
export M2_HOME=/usr/local/maven && \
export PATH=$PATH:$M2_HOME/bin && \
mvn package && \
mkdir -p /data/elasticsearch2.3/plugins/ik/ && \
unzip target/releases/elasticsearch-analysis-ik-1.9.0.zip -d /data/elasticsearch2.3/plugins/ik/ && \
echo -e "\nindex.analysis.analyzer.default.type: ik" >> /data/elasticsearch2.3/config/elasticsearch.yml

RUN rm -rf /opt/*

CMD ["/bin/sh", "/data/elasticsearch2.3/bin/elasticsearch", "-Des.insecure.allow.root=true"]

EXPOSE 9200
