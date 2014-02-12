#!/bin/bash
PHPADDR=$(env | grep PHP_ | grep _ADDR | sed "s|PHP_.*_ADDR=||") && sed -i "s|\(fastcgi_pass \).*\(:.*\)|\1$PHPADDR\2|g" /etc/nginx/sites-enabled/default
echo "The IP of the PHP Server in /etc/nginx/sites-enabled/default set to $PHPADDR"
