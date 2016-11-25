# Source of the operating system
FROM myregistrydomain.com:5000/alpine
ENV INITRD no

# update repository and operating system
RUN (apk update && apk upgrade -f -q)

# install mysql
RUN apk add --update mysql mysql-client

# cleanup apt
RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /var/cache/apk/*

# prepare mounting point
WORKDIR /app
VOLUME /app

# import mysql config file
COPY my.cnf /etc/mysql/my.cnf

# copy the startup script of the container
COPY scripts/run.sh /scripts/run.sh
RUN chmod -R 755 /scripts
RUN chmod +x /scripts/run.sh

EXPOSE 3306
CMD ["/scripts/run.sh"]
