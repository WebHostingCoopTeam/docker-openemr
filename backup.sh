#!/bin/bash
#this for reference only to create the backup scrips for each container ... the idea to use the same command for each container
#each container will have their own custum backup scritp for it ...

#Backup important file ... of the configuration ...
cp /etc/hosts /var/backups/

#Backup importand files relate to app
  cd /var/www/ 
  cp openemr/sites/default/config.php /var/backups/
  cp -R openemr/sites/default/documents   /var/backups/
  cp -R openemr/sites/default/era  /var/backups/
  cp -R openemr/sites/default/edi  /var/backups/
  cp -R openemr/sites/default/letter_templates  /var/backups/
