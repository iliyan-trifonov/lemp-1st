#!/bin/bash
MYSQLIPPHPFILE="/sites/mysqlserverip.php"
MYSQLADDR=$(env | grep MYSQL_ | grep _ADDR | sed "s|MYSQL_.*_ADDR=||") && echo "<?php define('MYSQLSERVERADDR','$MYSQLADDR');" > $MYSQLIPPHPFILE && chown www-data:www-data $MYSQLIPPHPFILE
echo "The IP of the MySQL Server ($MYSQLADDR) is stored in $MYSQLIPPHPFILE"
