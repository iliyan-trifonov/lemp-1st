#!/bin/bash
echo "Cleaning up any containers and images previously built by this script.."
docker kill nginxserver1 phpserver1 mysqlserver1
docker rm nginxserver1 phpserver1 mysqlserver1 SITES MYSQLDATA
docker rmi iliyan/mysqlserver iliyan/phpserver iliyan/nginxserver iliyan/mysqldata iliyan/sitesdata
echo "Building the images and containers.."
sh build_all.sh
