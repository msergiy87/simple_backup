# simple_backup - mysql dump and data backup. You can save last 5 daily logs in /data/backups/daily /data/backups/daily_mysql_dump and last 3 monthly backup (together data and mysql dump) in /data/backups/monthly_dump_and_data

1) create dirs

mkdir -p /data/backups/daily /data/backups/daily_mysql_dump /data/backups/monthly_dump_and_data

2 ) crontab -l

03 02 1 * *     /root/scripts/backup.sh monthly > /dev/null 2>&1

03 03 * * *     /root/scripts/mysql_backup.sh > /dev/null 2>&1

23 03 * * *     /root/scripts/backup.sh daily > /dev/null 2>&1

3) move logrotate files to /etc/

4) move scripts to /root/scripts/

5) change_logrotate.sh - create 