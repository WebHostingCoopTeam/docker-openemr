#!/bin/bash

set -e

if [ -f /etc/configured ]; then
  echo 'already configured'
else
  #code that need to run only one time ....
   a2enmod ssl
   a2ensite default-ssl
   a2enmod rewrite
  #needed for fix problem with ubuntu and cron
  update-locale
  date > /etc/configured
fi
