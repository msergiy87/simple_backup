#!/bin/bash
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:$PATH
#set -x

USER="fsbackup"
PASSWORD="mysecurepass"
OUTPUTDIR="/data/backups/daily_mysql_dump"

# check conditions
#------------------------------------------------------------------------------------------
if [ ! -d "$OUTPUTDIR" ]						# if not equal, not success
then
	mkdir -p "$OUTPUTDIR"
fi

#CREATE USER 'fsbackup'@'localhost' IDENTIFIED BY 'mysecurepass';
#GRANT SELECT, FILE, SHOW DATABASES, LOCK TABLES, SHOW VIEW ON *.* TO 'fsbackup'@'localhost' IDENTIFIED BY 'mysecurepass';
#flush privileges;

#/bin/rm $OUTPUTDIR/*

# get a list of databases
databases=$(mysql --user=$USER --password=$PASSWORD -e "SHOW DATABASES;" | tr -d "| " | grep -v Database)

# dump each database in turn
for db in $databases; do
	echo "$db"
	mysqldump --force --opt --user=$USER --password=$PASSWORD --databases "$db" > "$OUTPUTDIR/$db.sql"
	gzip "$OUTPUTDIR/$db.sql"
done

logrotate -f /etc/logrotate_backup_daily_mysql_dump.conf
