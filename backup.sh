#!/usr/bin/env bash
#set -x

# data
SITE_LOCATION="/var/www"
BACKUP_DIR="/data/backups"

# mysql
USER="fsbackup"
PASSWORD="mysecurepass"

#CREATE USER 'fsbackup'@'localhost' IDENTIFIED BY 'mysecurepass';
#GRANT SELECT, FILE, SHOW DATABASES, LOCK TABLES, SHOW VIEW ON *.* TO 'fsbackup'@'localhost' IDENTIFIED BY 'mysecurepass';
#flush privileges;

# check conditions
#------------------------------------------------------------------------------------------
if [ ! -d "$BACKUP_DIR" ]						# if not equal, not success
then
	mkdir -p "$BACKUP_DIR"/daily_data
	mkdir -p "$BACKUP_DIR"/daily_mysql_dump
	mkdir -p "$BACKUP_DIR"/monthly_dump_and_data
fi

case "$1" in
"daily" )

	DIR_LIST="$SITE_LOCATION \
	/etc \
	/root/scripts \
	/var/spool/cron/crontabs \
	/usr/local \
	/var/lib/mysql"
	# /home

	for DIR in $DIR_LIST
	do
		DOMAIN_NAME=$(basename "$DIR")
		tar --numeric-owner --exclude="$SITE_LOCATION/upfiles" -czpf "$BACKUP_DIR"/daily_data/"$DOMAIN_NAME".tar.gz "$DIR"
	done

	logrotate -f /etc/logrotate_backup_daily_data.conf
	chmod 600 /data/backups/daily_data/*
	;;

"mysql" )

	# get a list of databases
	databases=$(mysql --user=$USER --password=$PASSWORD -e "SHOW DATABASES;" | tr -d "| " | grep -v Database)

	# dump each database in turn
	for db in $databases; do
		mysqldump --force --opt --user=$USER --password=$PASSWORD --databases "$db" > "$BACKUP_DIR/daily_mysql_dump/$db.sql"
		gzip "$BACKUP_DIR/daily_mysql_dump/$db.sql"
	done

	logrotate -f /etc/logrotate_backup_daily_mysql_dump.conf
	chmod 600 /data/backups/daily_mysql_dump/*
	;;

"monthly" )

	#ls $SITE_LOCATION/upfiles/ > /root/scripts/upfiles_list
	#ls -l $SITE_LOCATION > /root/scripts/var_www_rules

	mv "$BACKUP_DIR"/daily_data/*.tar.gz.5 "$BACKUP_DIR"/monthly_dump_and_data/
	mv "$BACKUP_DIR"/daily_mysql_dump/*.sql.gz.5 "$BACKUP_DIR"/monthly_dump_and_data/

	logrotate -f /etc/logrotate_backup_monthly_dump_and_data.conf
	chmod 600 /data/backups/monthly_dump_and_data/*
	;;

esac
