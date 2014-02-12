#!/bin/bash
echo "Setting mysql IP.."
sh setmysqlip.sh
echo "Running php5-fpm.."
/usr/sbin/php5-fpm -F
echo "Showing the last lines from the PHP log.."
tail -n 30 /var/log/php5-fpm.log
