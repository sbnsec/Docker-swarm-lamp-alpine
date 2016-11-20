# Source du système d'exploitation
FROM myregistrydomain.com:5000/alpine
ENV INITRD no

# Mise à jour du dépôt, et mise à jour du système d'exploitation
RUN (apk update && apk upgrade -f -q)

RUN (apk add apache2 php5-apache2 curl php5-cli php5-json php5-openssl php5)
RUN rm -f /var/cache/apk/* && \
mkdir /app && chown -R apache:apache /app && \
sed -i 's#^DocumentRoot ".*#DocumentRoot "/app"#g' /etc/apache2/httpd.conf && \
sed -i 's#AllowOverride none#AllowOverride All#' /etc/apache2/httpd.conf && \
echo "Success"

RUN mkdir -p /run/apache2

ADD scripts/run.sh /scripts/run.sh
RUN chmod -R 755 /scripts

EXPOSE 80

# VOLUME /app
WORKDIR /app

#ENTRYPOINT ["/scripts/run.sh"]
CMD ["/scripts/run.sh"]


