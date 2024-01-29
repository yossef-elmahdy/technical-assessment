#!/bin/bash

# and day of week (dow) or use '*' in these fields (for 'any').
# 
# Notice that tasks will be started based on the cron's system
# daemon's notion of time and timezones.
# 
# Output of the crontab jobs (including errors) is sent through
# email to the user the crontab file belongs to (unless redirected).
# 
# For example, you can run a backup of all your user accounts
# at 5 a.m every week with:
# 0 5 * * 1 tar -zcf /var/backups/home.tgz /home/
# 
# For more information see the manual pages of crontab(5) and cron(8)
# 
# m h  dom mon dow   command
*/2 * * * *  exec python3 /app/extract_transform_load_data.py --user root --password root --host postgres-db --port 5432 --db RetailDB --base_url https://github.com/yossef-elmahdy/technical-assessment/releases/download/online-retail-data/        