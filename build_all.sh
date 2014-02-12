#! /bin/bash

echo "Creating and running the data volumes.."
cd mysql/data
docker build -t iliyan/mysqldata .
docker run -name MYSQLDATA iliyan/mysqldata
cd ../../sites/data
docker build -t iliyan/sitesdata .
docker run -name SITES iliyan/sitesdata
echo "Ready!"
cd ../../mysql

echo "Creating the basic mysqlserver.."
docker build -rm -t iliyan/mysqlserver:basic .
echo "Ready!"

cd ..

echo "Preparing the /mysqldata dir on the data volume link.."
docker run -rm -volumes-from MYSQLDATA iliyan/mysqlserver:basic chown mysql:mysql /mysqldata
docker run -rm -volumes-from MYSQLDATA iliyan/mysqlserver:basic chmod 0755 /mysqldata
docker run -rm -volumes-from MYSQLDATA iliyan/mysqlserver:basic /usr/bin/mysql_install_db
echo "Ready!"

echo "Preparing the mysql db using the new mysql image.."
docker run -rm -volumes-from MYSQLDATA iliyan/mysqlserver:basic sh /preparedb.sh
echo "Ready!"

echo "Creating the php5-fpm container.."
cd php
docker build -rm -t iliyan/phpserver .
echo "Ready!"

cd ..

echo "Preparing the /sites/phpmyadmin dir using the new php image.."
docker run -rm -volumes-from SITES iliyan/phpserver sh /install_phpmyadmin.sh
echo "Ready!"

echo "Creating the nginx container.."
cd nginx
docker build -rm -t iliyan/nginxserver .
echo "Ready!"

cd ..

echo "Preparing the /sites dir on the data volume link using the nginx container.."
docker run -rm -volumes-from SITES iliyan/nginxserver mv /tmp/index.php /sites/
docker run -rm -volumes-from SITES iliyan/nginxserver mv /tmp/phpinfo.php /sites/
docker run -rm -volumes-from SITES iliyan/nginxserver chown -R www-data:www-data /sites
docker run -rm -volumes-from SITES iliyan/nginxserver chmod -R 0755 /sites
echo "Ready!"


echo "Running the mysqlserver:basic with all needed params.."
docker run -d -volumes-from MYSQLDATA -expose 3306 -name mysqlserver1 iliyan/mysqlserver:basic
echo "Ready!"

echo "Running the phpserver with all needed params.."
docker run -d -volumes-from SITES -link mysqlserver1:mysql -expose 9000 -name phpserver1 iliyan/phpserver
echo "Ready!"

echo "Running the nginxserver with all needed params.."
docker run -d -volumes-from SITES -link phpserver1:php -p 8080:80 -name nginxserver1 iliyan/nginxserver
echo "Ready!"

echo "Sleeping 10s.." && sleep 10

echo "Listing all running containers.."
docker ps

echo "Calling localhost:8080 to test the containers connections.."
curl localhost:8080

echo "Finished!"
