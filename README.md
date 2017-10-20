# simple_backup

mysql dump and data backup. You can save last 5 daily backups in /data/backups/daily_data /data/backups/daily_mysql_dump and last 3 monthly backup (together data and mysql dump) in /data/backups/monthly_dump_and_data. Monthly backup contains data for 4 days before the end of the each month.

Distros tested
------------
Currently, this is only tested on Debian 7.9. It should theoretically work on older versions of Ubuntu or Debian based systems.

Usage
------------

1 ) add crontab tasks
```
03 02 1 * *     /root/scripts/backup.sh monthly > /dev/null 2>&1
03 03 * * *     /root/scripts/mysql_backup.sh > /dev/null 2>&1
23 03 * * *     /root/scripts/backup.sh daily > /dev/null 2>&1
```
2 ) change rights and owner
```
chmod 744 *.sh
chmod 644 logrotate_backup_*
chmown root:root ../simple_backup -R
```
3 ) move logrotate files to /etc/

4 ) move scripts to /root/scripts/

5 ) change var SITE_LOCATION and create mysql user

6 ) change_logrotate.sh - create or change logrotate scenario for sites 
