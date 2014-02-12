#!/bin/bash
echo "Running the mysql server.."
/usr/bin/mysqld_safe &
echo "Sleeping 10s while waiting for the MySQL server to finish starting.." && sleep 10
echo "Creating the docker/docker master user if it doesn't exist.."
echo "GRANT ALL PRIVILEGES ON *.* TO 'docker'@'%' IDENTIFIED BY 'docker' WITH GRANT OPTION; FLUSH PRIVILEGES;" | mysql
echo "Shutting down the MySQL Server.."
mysqladmin -uroot -h127.0.0.1 --protocol=tcp shutdown
echo "Showing the last lines of the MySQL log:"
tail -n 30 /var/log/mysql/error.log
