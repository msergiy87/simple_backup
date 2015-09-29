#!/bin/bash
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:$PATH

SITE_LOCATION="/home"
BACKUP_DIR="/data/backups"
ROTATE="/usr/sbin/logrotate -f"
DATE=`date +%d-%m-%Y`

case $1 in
"daily" )

	for i in `find $SITE_LOCATION -mindepth 1 -maxdepth 1 -type d -user www-data`
	do
		SITE_ROOT=$i
		DOMAIN_NAME=`basename $i`

		tar --numeric-owner -czpf $BACKUP_DIR/daily/$DOMAIN_NAME.tar.gz $SITE_ROOT/public_html
	done

	$ROTATE /etc/logrotate_backup_daily.conf
	;;

"monthly" )
	mv $BACKUP_DIR/daily/*.tar.gz.5 $BACKUP_DIR/monthly_dump_and_data/
	mv $BACKUP_DIR/daily_mysql_dump/*.sql.gz.5 $BACKUP_DIR/monthly_dump_and_data/
	$ROTATE /etc/logrotate_backup_monthly.conf
	;;
esac
