#!/bin/bash
echo "Installing and configuring phpMyAdmin.."
cd /sites
echo "Installing wget.."
apt-get install -qq wget
echo "Downloading phpMyAdmin.."
wget http://sourceforge.net/projects/phpmyadmin/files/phpMyAdmin/4.1.7/phpMyAdmin-4.1.7-all-languages.tar.gz
echo "Extracting the archive.."
tar xzvf phpMyAdmin-4.1.7-all-languages.tar.gz && rm phpMyAdmin-4.1.7-all-languages.tar.gz
ln -s phpMyAdmin-4.1.7-all-languages/ phpmyadmin
cd phpmyadmin
cp config.sample.inc.php config.inc.php
sed -i "s|\(\$cfg.*\['host'\].*=\).*;|require_once '/sites/mysqlserverip.php';\n\1MYSQLSERVERADDR;|" config.inc.php
head -n 32 config.inc.php
echo "phpMyAdmin configured!"
