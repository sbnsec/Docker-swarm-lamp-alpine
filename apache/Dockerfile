# Source of the operating system
FROM myregistrydomain.com:5000/alpine
ENV INITRD no

# update repository and operating system
RUN (apk update && apk upgrade -f -q)

#  install php apache and extenstion
RUN (apk add apache2 php5-apache2 curl php5-cli php5-json php5-openssl php5 apache2-utils)

# telegraf installation
ENV TELEGRAF_VERSION 1.1.1
RUN apk add --no-cache ca-certificates
RUN update-ca-certificates
RUN apk add --no-cache --virtual .build-deps wget gnupg tar
RUN gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 05CE15085FC09D18E99EFB22684A14CF2582E0C5
RUN wget -q https://dl.influxdata.com/telegraf/releases/telegraf-${TELEGRAF_VERSION}-static_linux_amd64.tar.gz.asc
RUN wget -q https://dl.influxdata.com/telegraf/releases/telegraf-${TELEGRAF_VERSION}-static_linux_amd64.tar.gz
RUN gpg --batch --verify telegraf-${TELEGRAF_VERSION}-static_linux_amd64.tar.gz.asc telegraf-${TELEGRAF_VERSION}-static_linux_amd64.tar.gz
RUN mkdir -p /usr/src /etc/telegraf
RUN tar -C /usr/src -xzf telegraf-${TELEGRAF_VERSION}-static_linux_amd64.tar.gz
RUN mv /usr/src/telegraf*/telegraf.conf /etc/telegraf/
RUN chmod +x /usr/src/telegraf*/*
RUN cp -a /usr/src/telegraf*/* /usr/bin/
RUN rm -rf *.tar.gz* /usr/src /root/.gnupg
RUN apk del .build-deps

# cleanup apt
RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /var/cache/apk/*

# preparing apache environment
RUN mkdir -p /run/apache2
COPY httpd.conf /etc/apache2/

# copy config file of telegraf
COPY telegraf.conf /etc/telegraf/

# copy the startup script of the container
COPY scripts/run.sh /scripts/run.sh
RUN chmod -R 755 /scripts
RUN chmod +x /scripts/run.sh

EXPOSE 80
CMD ["/scripts/run.sh"]


