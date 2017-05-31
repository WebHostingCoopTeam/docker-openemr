#name of container: docker-openemr
#versison of container: 0.3.1
#FROM quantumobject/docker-baseimage:15.04
#MAINTAINER Angel Rodriguez "angel@quantumobject.com"
FROM ubuntu:xenial

#add repository and update the container
#Installation of nesesary package/software for this containers...
RUN apt-get update && apt-get install -y -q apache2 \
                                            gdebi \
                                            wget \
                                            locales \
                                      && cd /tmp; wget -c http://sourceforge.net/projects/openemr/files/OpenEMR%20Ubuntu_debian%20Package/5.0.0/openemr-php7_5.0.0-1_all.deb \
                                      && gdebi openemr-php7_5.0.0-1_all.deb \
                                      && update-locale \
                                      && apt-get clean \
                                      && rm -rf /tmp/* /var/tmp/* \
                                      && rm -rf /var/lib/apt/lists/*

#General variable definition....
##startup scripts
COPY php.ini /etc/php5/apache2/php.ini
COPY apache2.conf /etc/apache2/apache2.conf

RUN cp /var/log/cron/config /var/log/apache2/ \
    && chown -R www-data /var/log/apache2

#backup or keep data integrity ..
##scritp that can be running from the outside using docker exec tool ...
COPY backup.sh /sbin/backup
RUN chmod +x /sbin/backup
VOLUME /var/backups

EXPOSE 80

COPY start.sh /start.sh

# Use baseimage-docker's init system.
CMD ["/start.sh"]
