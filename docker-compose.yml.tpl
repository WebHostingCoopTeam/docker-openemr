version: '2'
services:
  openemr:
    restart: always
    image: ${TAG}
    ports:
    - 80:8080
    labels:
      io.rancher.sidekicks: openemr-data,db
    hostname: ${openemr_host}.${openemr_domain}
    environment:
    - MYSQL_ROOT_PASSWORD=${DB_PASS}
  db:
    restart: always
    image: mysql:5.7
    volumes_from:
    - openemr-data
    labels:
      io.rancher.sidekicks: openemr-data
    environment:
    - MYSQL_ROOT_PASSWORD=${DB_PASS}
  openemr-data:
    labels:
      io.rancher.container.start_once: 'true'
      io.rancher.container.hostname_override: container_name
      io.rancher.container.pull_image: always
    command: /bin/true
    image: busybox
    volume_driver: ${VOLUME_DRIVER}
    volumes:
    - /var/lib/mysql
