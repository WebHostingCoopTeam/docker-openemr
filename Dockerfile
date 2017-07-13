#name of container: docker-openemr
#versison of container: 0.3.1
#FROM quantumobject/docker-baseimage:15.04
#MAINTAINER Angel Rodriguez "angel@quantumobject.com"
FROM ubuntu:xenial

#add repository and update the container
#Installation of nesesary package/software for this containers...
RUN DEBIAN_FRONTEND=noninteractive apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y -q apache2 \
    gdebi \
    wget \
    locales \
    mysql-server \
    makepasswd \
    libapache2-mod-php \
    libdate-calc-perl \
    libdbd-mysql-perl \
    libdbi-perl \
    libtiff-tools \
    libwww-mechanize-perl \
    libxml-parser-perl \
    php \
    php-cli \
    php-gd \
    php-xsl \
    php-curl \
    php-mysql \
    php-mcrypt \
    php-soap \
    php-json \
    imagemagick \
    php-gettext \
    php-mbstring \
    php-zip \
  && cd /tmp; wget -cq http://sourceforge.net/projects/openemr/files/OpenEMR%20Ubuntu_debian%20Package/5.0.0/openemr-php7_5.0.0-1_all.deb \
  && cd /tmp; DEBIAN_FRONTEND=noninteractive dpkg -i openemr-php7_5.0.0-1_all.deb \
  && update-locale \
  #&&  DEBIAN_FRONTEND=noninteractive apt-get -yqq remove mysql-server \
  && DEBIAN_FRONTEND=noninteractive apt-get clean \
  && rm -rf /tmp/* /var/tmp/* \
  && rm -rf /var/lib/apt/lists/*


#General variable definition....
##startup scripts
COPY php.ini /etc/php5/apache2/php.ini
COPY apache2.conf /etc/apache2/apache2.conf

# RUN cp /var/log/cron/config /var/log/apache2/
RUN chown -R www-data /var/log/apache2 \
&& chown -R www-data:www-data /var/www/openemr

#backup or keep data integrity ..
##scritp that can be running from the outside using docker exec tool ...
VOLUME /var/backups

EXPOSE 80

COPY assets /assets
RUN chmod +x /assets/backup.sh \
&& chmod +x /assets/start

# Use baseimage-docker's init system.
CMD ["/assets/start"]
