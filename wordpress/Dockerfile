# Source of the operating system
FROM myregistrydomain.com:5000/alpine
ENV INITRD no

# update repository and operating system
RUN (apk update && apk upgrade -f -q)

#  install php apache and extenstion
RUN (apk add apache2 php5-apache2 curl php5-cli php5-json php5-openssl php5 apache2-utils php5-mysql)

# update tar package
RUN apk --update add tar

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

# preparing apache & PHP environment
RUN mkdir -p /run/apache2
RUN rm /var/www/localhost/htdocs/index.html
COPY httpd.conf /etc/apache2/
COPY php.ini /etc/php5/

# download and extract wordpress
ENV WORDPRESS_VERSION "4.6.1-fr_FR"
ENV WORDPRESS_MD5 "47698f1e8c41a024e38a2ee233fa076a"
RUN set -x \
	&& curl -o wordpress.tar.gz -fSL "https://fr.wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz" \
	&& tar -xzf wordpress.tar.gz --strip-components=1 -C /var/www/localhost/htdocs \
	&& rm wordpress.tar.gz \
	&& chown -R apache:apache /var/www/localhost/htdocs

# copy wordpress config file
COPY wp-config.php /var/www/localhost/htdocs/wp-config.php

# copy config file of telegraf
COPY telegraf.conf /etc/telegraf/

# copy the startup script of the container
COPY scripts/run.sh /scripts/run.sh
RUN chmod -R 755 /scripts
RUN chmod +x /scripts/run.sh

EXPOSE 80
CMD ["/scripts/run.sh"]
