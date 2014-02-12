FROM ubuntu:13.10

RUN echo "deb mirror://mirrors.ubuntu.com/mirrors.txt saucy main restricted universe multiverse" > /etc/apt/sources.list && echo "deb mirror://mirrors.ubuntu.com/mirrors.txt saucy-updates main restricted universe multiverse" >> /etc/apt/sources.list && echo "deb mirror://mirrors.ubuntu.com/mirrors.txt saucy-backports main restricted universe multiverse" >> /etc/apt/sources.list && echo "deb mirror://mirrors.ubuntu.com/mirrors.txt saucy-security main restricted universe multiverse" >> /etc/apt/sources.list

RUN cat /proc/mounts > /etc/mtab

RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get -qq install mysql-server

RUN sed -i '/bind-address/  s|^|#|' /etc/mysql/my.cnf && sed -i 's|\(datadir.*=\).*|\1/mysqldata|' /etc/mysql/my.cnf

ADD preparedb.sh /preparedb.sh

EXPOSE 3306

CMD ["/usr/bin/mysqld_safe"]