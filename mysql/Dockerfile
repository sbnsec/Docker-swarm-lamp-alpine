# Source of the operating system
FROM myregistrydomain.com:5000/alpine
ENV INITRD no

# update repository and operating system
RUN (apk update && apk upgrade -f -q)

# install mysql
RUN apk add --update mysql mysql-client

# telegraf installation
ENV TELEGRAF_VERSION 1.1.1
RUN apk add --no-cache ca-certificates && \
    update-ca-certificates
RUN apk add --no-cache --virtual .build-deps wget gnupg tar && \
    gpg --keyserver hkp://ha.pool.sks-keyservers.net \
        --recv-keys 05CE15085FC09D18E99EFB22684A14CF2582E0C5 && \
    wget -q https://dl.influxdata.com/telegraf/releases/telegraf-${TELEGRAF_VERSION}-static_linux_amd64.tar.gz.asc && \
    wget -q https://dl.influxdata.com/telegraf/releases/telegraf-${TELEGRAF_VERSION}-static_linux_amd64.tar.gz && \
    gpg --batch --verify telegraf-${TELEGRAF_VERSION}-static_linux_amd64.tar.gz.asc telegraf-${TELEGRAF_VERSION}-static_linux_amd64.tar.gz && \
    mkdir -p /usr/src /etc/telegraf && \
    tar -C /usr/src -xzf telegraf-${TELEGRAF_VERSION}-static_linux_amd64.tar.gz && \
    mv /usr/src/telegraf*/telegraf.conf /etc/telegraf/ && \
    chmod +x /usr/src/telegraf*/* && \
    cp -a /usr/src/telegraf*/* /usr/bin/ && \
    rm -rf *.tar.gz* /usr/src /root/.gnupg && \
apk del .build-deps

# cleanup apt
RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /var/cache/apk/*

# prepare mounting point
WORKDIR /app
VOLUME /app

# import mysql config file
COPY my.cnf /etc/mysql/my.cnf

# copy config file of telegraf
COPY telegraf.conf /etc/telegraf/

# copy the startup script of the container
COPY scripts/run.sh /scripts/run.sh
RUN chmod -R 755 /scripts
RUN chmod +x /scripts/run.sh

EXPOSE 3306
CMD ["/scripts/run.sh"]
