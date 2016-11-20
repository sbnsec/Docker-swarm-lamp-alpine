
# Source of the operating system
FROM myregistrydomain.com:5000/alpine
ENV INITRD no

# update repository and operating system
RUN (apk update && apk upgrade -f -q)

#  install php apache and extenstion
RUN (apk add apache2 php5-apache2 curl php5-cli php5-json php5-openssl php5)

# Les's cleanup apt
RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /var/cache/apk/*


RUN mkdir /app && chown -R apache:apache /app && \
sed -i 's#^DocumentRoot ".*#DocumentRoot "/app/wordpress"#g' /etc/apache2/httpd.conf && \
sed -i 's#AllowOverride none#AllowOverride All#' /etc/apache2/httpd.conf && \
echo "Success"

RUN mkdir -p /run/apache2

# VOLUME /app
WORKDIR /app/wordpress


# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php

ENV WORDPRESS_VERSION "4.6.1-fr_FR"
ENV WORDPRESS_MD5 "47698f1e8c41a024e38a2ee233fa076a"

RUN set -x \
	&& curl -o wordpress.tar.gz -fSL "https://fr.wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz" \
	&& tar -xzf wordpress.tar.gz -C /app/ \
	&& rm wordpress.tar.gz \
	&& chown -R apache:apache /app/wordpress

COPY docker-entrypoint.sh /usr/local/bin/

RUN mv  /app/wordpress/wp-config-sample.php /app/wordpress/wp-config.php
RUN sed -i 's#votre_nom_de_bdd#wordpress#' /app/wordpress/wp-config.php
RUN sed -i 's#votre_utilisateur_de_bdd#wordpress#' /app/wordpress/wp-config.php
RUN sed -i 's#votre_mdp_de_bdd#w0rdpressp@SS#' /app/wordpress/wp-config.php
RUN sed -i 's#localhost#10.0.9.3#' /app/wordpress/wp-config.php

EXPOSE 80
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
CMD ["/usr/local/bin/docker-entrypoint.sh"]


