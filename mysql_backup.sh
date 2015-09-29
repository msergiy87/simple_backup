#!/bin/bash
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:$PATH

USER="fsbackup"
PASSWORD="mysecurepass"
OUTPUTDIR="/data/backups/daily_mysql_dump"
MYSQLDUMP="/usr/bin/mysqldump"
MYSQL="/usr/bin/mysql"
DATE=`date +%Y%m%d`
ROTATE="/usr/sbin/logrotate -f"

# check conditions
#------------------------------------------------------------------------------------------
ls $OUTPUTDIR > /dev/null 2>&1
if [ $? -ne 0 ]							# if not equal, not success
then
	/bin/mkdir -p $OUTPUTDIR
fi

#CREATE USER 'fsbackup'@'localhost' IDENTIFIED BY '';
#GRANT SELECT, FILE, SHOW DATABASES, LOCK TABLES, SHOW VIEW ON *.* TO 'fsbackup'@'localhost' IDENTIFIED BY '';

#/bin/rm $OUTPUTDIR/*

# get a list of databases
databases=`$MYSQL --user=$USER --password=$PASSWORD -e "SHOW DATABASES;" | tr -d "| " | grep -v Database`

# dump each database in turn
for db in $databases; do
    echo $db
    $MYSQLDUMP --force --opt --user=$USER --password=$PASSWORD --databases $db > "$OUTPUTDIR/$db.sql"
    gzip "$OUTPUTDIR/$db.sql"
done

$ROTATE /etc/logrotate_mysql_dump_daily.conf 
