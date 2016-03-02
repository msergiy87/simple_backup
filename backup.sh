#!/bin/bash
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:$PATH
#set -x

SITE_LOCATION="/home"
BACKUP_DIR="/data/backups"

# check conditions
#------------------------------------------------------------------------------------------
if [ ! -d "$BACKUP_DIR" ]						# if not equal, not success
then
	mkdir -p "$BACKUP_DIR"/daily_data
	mkdir -p "$BACKUP_DIR"/monthly_dump_and_data
fi

case "$1" in
"daily" )

	find $SITE_LOCATION -mindepth 1 -maxdepth 1 -type d -user www-data >> /tmp/bk_list_of_dirs

	while read -r SITE_ROOT
	do
		DOMAIN_NAME=$(basename "$SITE_ROOT")
		tar --numeric-owner -czpf "$BACKUP_DIR"/daily_data/"$DOMAIN_NAME".tar.gz "$SITE_ROOT"/public_html
	done < /tmp/bk_list_of_dirs

	logrotate -f /etc/logrotate_backup_daily_data.conf
	rm /tmp/bk_list_of_dirs
	;;

"monthly" )
	mv "$BACKUP_DIR"/daily_data/*.tar.gz.5 "$BACKUP_DIR"/monthly_dump_and_data/
	mv "$BACKUP_DIR"/daily_mysql_dump/*.sql.gz.5 "$BACKUP_DIR"/monthly_dump_and_data/
	logrotate -f /etc/logrotate_backup_monthly_dump_and_data.conf
	;;
esac
