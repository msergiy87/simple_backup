#!/bin/bash
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:$PATH
#set -x

SITE_LOCATION="/home"
BACKUP_DIR="/data/backups"

# check conditions
#------------------------------------------------------------------------------------------
if [ ! -d "$BACKUP_DIR" ]						# if not equal, not success
then
	mkdir -p "$BACKUP_DIR"/daily
	mkdir -p "$BACKUP_DIR"/monthly_dump_and_data
fi

case "$1" in
"daily" )

	while SITE_ROOT in "$(find $SITE_LOCATION -mindepth 1 -maxdepth 1 -type d -user www-data)"
	do
		DOMAIN_NAME=$(basename "$SITE_ROOT")
		tar --numeric-owner -czpf "$BACKUP_DIR"/daily/"$DOMAIN_NAME".tar.gz "$SITE_ROOT"/public_html
	done

	logrotate -f /etc/logrotate_backup_daily.conf
	;;

"monthly" )
	mv "$BACKUP_DIR"/daily/*.tar.gz.5 "$BACKUP_DIR"/monthly_dump_and_data/
	mv "$BACKUP_DIR"/daily_mysql_dump/*.sql.gz.5 "$BACKUP_DIR"/monthly_dump_and_data/
	logrotate -f /etc/logrotate_backup_monthly.conf
	;;
esac
