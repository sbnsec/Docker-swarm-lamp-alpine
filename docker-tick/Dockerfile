FROM debian:latest
ENV DEBIAN_FRONTEND noninteractive
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt-get update && apt-get install -y wget redis-server apt-transport-https dialog apt-utils python-httplib2 python-apt curl supervisor net-tools 

RUN wget https://dl.influxdata.com/influxdb/releases/influxdb_1.2.2_amd64.deb && dpkg -i influxdb_1.2.2_amd64.deb
RUN wget https://dl.influxdata.com/kapacitor/releases/kapacitor_1.2.0_amd64.deb && dpkg -i kapacitor_1.2.0_amd64.deb
RUN wget https://dl.influxdata.com/chronograf/releases/chronograf_1.2.0~beta7_amd64.deb && dpkg -i chronograf_1.2.0~beta7_amd64.deb
RUN wget https://dl.influxdata.com/telegraf/releases/telegraf_1.2.1_amd64.deb && dpkg -i telegraf_1.2.1_amd64.deb

ADD influxdb.conf /etc/influxdb/influxdb.conf
ADD config.toml /opt/chronograf/config.toml
ADD kapacitor.conf /etc/kapacitor/kapacitor.conf
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD telegraf.conf /etc/telegraf/telegraf.conf
ADD start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

EXPOSE 8083 8086 8088 8888
ENTRYPOINT ["/usr/local/bin/start.sh"]
#CMD     ["/usr/bin/supervisord"]

