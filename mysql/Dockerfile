FROM myregistrydomain.com:5000/alpine
ENV INITRD no

# Mise à jour du dépôt, et mise à jour du système d'exploitation
RUN (apk update && apk upgrade -f -q)
RUN apk add --update mysql mysql-client && rm -f /var/cache/apk/*

WORKDIR /app
VOLUME /app

COPY scripts/run.sh /scripts/run.sh
RUN chmod -R 755 /scripts

COPY my.cnf /etc/mysql/my.cnf

EXPOSE 3306
CMD ["/scripts/run.sh"]
