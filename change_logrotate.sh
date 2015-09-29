#!/bin/bash

# automatic configuration change logrotate rules for site

SITE_LOCATION="/home"
APACHE_GROUP="www-data"

for i in `find $SITE_LOCATION -mindepth 1 -maxdepth 1 -type d -user www-data`
do

SITE_ROOT=$i
DOMAIN_NAME=`basename $i`
LOGROTATE_CONFIG="/etc/logrotate.d/apache2-$DOMAIN_NAME"


echo "$SITE_ROOT/logs/error.log {" > $LOGROTATE_CONFIG
echo '        daily' >> $LOGROTATE_CONFIG  
echo '        missingok' >> $LOGROTATE_CONFIG
echo '        rotate 2' >> $LOGROTATE_CONFIG
echo '        size 10M' >> $LOGROTATE_CONFIG
echo '        compress' >> $LOGROTATE_CONFIG
echo '        delaycompress' >> $LOGROTATE_CONFIG
echo '        notifempty' >> $LOGROTATE_CONFIG
echo "        create 640 root $APACHE_GROUP" >> $LOGROTATE_CONFIG
echo '        sharedscripts' >> $LOGROTATE_CONFIG
echo '        postrotate' >> $LOGROTATE_CONFIG
echo '                if [ -f "`. /etc/apache2/envvars ; echo ${APACHE_PID_FILE:-/var/run/apache2.pid}`" ]; then' >> $LOGROTATE_CONFIG
echo '                        /etc/init.d/apache2 reload > /dev/null' >> $LOGROTATE_CONFIG
echo '                fi' >> $LOGROTATE_CONFIG
echo '        endscript' >> $LOGROTATE_CONFIG
echo '}' >> $LOGROTATE_CONFIG
echo '' >> $LOGROTATE_CONFIG

echo "$SITE_ROOT/logs/access.log {" >> $LOGROTATE_CONFIG
echo '        daily' >> $LOGROTATE_CONFIG
echo '        missingok' >> $LOGROTATE_CONFIG
echo '        rotate 2' >> $LOGROTATE_CONFIG
echo '        size 10M' >> $LOGROTATE_CONFIG
echo '        compress' >> $LOGROTATE_CONFIG
echo '        delaycompress' >> $LOGROTATE_CONFIG
echo '        notifempty' >> $LOGROTATE_CONFIG
echo "        create 640 root $APACHE_GROUP" >> $LOGROTATE_CONFIG
echo '        sharedscripts' >> $LOGROTATE_CONFIG
echo '        postrotate' >> $LOGROTATE_CONFIG
echo '                if [ -f "`. /etc/apache2/envvars ; echo ${APACHE_PID_FILE:-/var/run/apache2.pid}`" ]; then' >> $LOGROTATE_CONFIG
echo '                        /etc/init.d/apache2 reload > /dev/null' >> $LOGROTATE_CONFIG
echo '                fi' >> $LOGROTATE_CONFIG
echo '        endscript' >> $LOGROTATE_CONFIG
echo '}' >> $LOGROTATE_CONFIG
echo '' >> $LOGROTATE_CONFIG

done
