FROM debian:latest
ENV DEBIAN_FRONTEND noninteractive
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt-get update && apt-get install -y redis-server apt-transport-https dialog apt-utils python-httplib2 python-apt curl supervisor net-tools 

RUN curl -sL https://repos.influxdata.com/influxdb.key | apt-key add -
RUN echo "deb https://repos.influxdata.com/debian jessie stable" | tee /etc/apt/sources.list.d/influxdb.list

RUN apt-get update && apt-get -y install influxdb chronograf kapacitor


ADD influxdb.conf /etc/influxdb/influxdb.conf
ADD config.toml /opt/chronograf/config.toml
ADD kapacitor.conf /etc/kapacitor/kapacitor.conf
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

EXPOSE  80 9092 8125/udp 10000 8083 8086 8888
ENTRYPOINT ["/usr/local/bin/start.sh"]
#CMD     ["/usr/bin/supervisord"]

