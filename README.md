# simple_backup

Debian Wheezy support

mysql dump and data backup. You can save last 5 daily backups in /data/backups/daily_data /data/backups/daily_mysql_dump and last 3 monthly backup (together data and mysql dump) in /data/backups/monthly_dump_and_data. Monthly backup contains data for 4 days before the end of the month.

1 ) crontab -l

03 02 1 * *     /root/scripts/backup.sh monthly > /dev/null 2>&1

03 03 * * *     /root/scripts/mysql_backup.sh > /dev/null 2>&1

23 03 * * *     /root/scripts/backup.sh daily > /dev/null 2>&1

2) move logrotate files to /etc/

3) move scripts to /root/scripts/

4) change_logrotate.sh - create or change logrotate scenario for sites 
