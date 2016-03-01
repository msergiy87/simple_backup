#!/bin/bash
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:$PATH
#set -x

# automatic configuration change logrotate rules for site

SITE_LOCATION="/home"
APACHE_GROUP="www-data"

while SITE_ROOT in "$(find $SITE_LOCATION -mindepth 1 -maxdepth 1 -type d -user www-data)"
do

	DOMAIN_NAME=$(basename "$SITE_ROOT")
	LOGROTATE_CONFIG="/etc/logrotate.d/apache2-$DOMAIN_NAME"

	echo "$SITE_ROOT/logs/error.log {" > "$LOGROTATE_CONFIG"
	{
		echo "        daily"
		echo "        missingok"
		echo "        rotate 2"
		echo "        size 10M"
		echo "        compress"
		echo "        delaycompress"
		echo "        notifempty"
		echo "        create 640 root $APACHE_GROUP"
		echo "        sharedscripts"
		echo "        postrotate"
		echo '                if [ -f "`. /etc/apache2/envvars ; echo ${APACHE_PID_FILE:-/var/run/apache2.pid}`" ]; then'
		echo "                        /etc/init.d/apache2 reload > /dev/null"
		echo "                fi"
		echo "        endscript"
		echo "}"
		echo ""
		echo "$SITE_ROOT/logs/access.log {"
		echo "        daily"
		echo "        missingok"
		echo "        rotate 2"
		echo "        size 10M"
		echo "        compress"
		echo "        delaycompress"
		echo "        notifempty"
		echo "        create 640 root $APACHE_GROUP"
		echo "        sharedscripts"
		echo "        postrotate"
		echo '                if [ -f "`. /etc/apache2/envvars ; echo ${APACHE_PID_FILE:-/var/run/apache2.pid}`" ]; then'
		echo "                        /etc/init.d/apache2 reload > /dev/null"
		echo "                fi"
		echo "        endscript"
		echo "}"
	} >> "$LOGROTATE_CONFIG"
done
