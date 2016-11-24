# Source of the operating system
FROM myregistrydomain.com:5000/alpine
ENV INITRD no

# update repository and operating system
RUN (apk update && apk upgrade -f -q)

#  install php apache and extenstion
RUN (apk add apache2 php5-apache2 curl php5-cli php5-json php5-openssl php5 apache2-utils)

# cleanup apt
RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /var/cache/apk/*

# preparing apache environment
RUN mkdir -p /run/apache2
COPY httpd.conf /etc/apache2/

# copy the startup script of the container
COPY scripts/run.sh /scripts/run.sh
RUN chmod -R 755 /scripts
RUN chmod +x /scripts/run.sh

EXPOSE 80
CMD ["/scripts/run.sh"]


