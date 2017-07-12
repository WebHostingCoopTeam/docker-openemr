#!/bin/sh

set -e

if [ -f /etc/configured ]; then
  echo 'already configured'
else
  #code that need to run only one time ....
  a2enmod rewrite
   
   chown -R www-data:www-data /var/www/openemr/gacl/admin/templates_c
   chown -R www-data:www-data /var/www/openemr/sites/default/edi
   chown -R www-data:www-data /var/www/openemr/sites/default/era
   chown -R www-data:www-data /var/www/openemr/sites/default/documents
   chown -R www-data:www-data /var/www/openemr/sites/default/letter_templates
   chown -R www-data:www-data /var/www/openemr/library/freeb
   chown -R www-data:www-data /var/www/openemr/interface/main/calendar/modules/PostCalendar/pntemplates/compiled
   chown -R www-data:www-data /var/www/openemr/interface/main/calendar/modules/PostCalendar/pntemplates/cache
   
  #needed for fix problem with ubuntu and cron
  update-locale
  date > /etc/configured
fi

cd /var/www
    chmod 644 openemr/library/sqlconf.php 
    chmod 600 openemr/acl_setup.php 
    chmod 600 openemr/acl_upgrade.php 
   # chmod 600 openemr/sl_convert.php
    chmod 600 openemr/setup.php 
    chmod 600 openemr/sql_upgrade.php 
    chmod 600 openemr/gacl/setup.php 
    chmod 600 openemr/ippf_upgrade.php

#remove the basic page for apache
rm -R /var/www/html
#to fix error relate to ip address of container  apache2
echo "ServerName localhost" | tee /etc/apache2/conf-available/fqdn.conf
ln -s /etc/apache2/conf-available/fqdn.conf /etc/apache2/conf-enabled/fqdn.conf
#change document root
sed -i 's/DocumentRoot \/var\/www\/html/DocumentRoot \/var\/www\/openemr/' /etc/apache2/sites-available/000-default.conf
# chown
chown -R www-data:www-data /var/www/openemr

source /etc/apache2/envvars
apache2ctl -D FOREGROUND 2>&1
