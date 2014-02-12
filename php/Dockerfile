FROM ubuntu:13.10

RUN echo "deb mirror://mirrors.ubuntu.com/mirrors.txt saucy main restricted universe multiverse" > /etc/apt/sources.list && echo "deb mirror://mirrors.ubuntu.com/mirrors.txt saucy-updates main restricted universe multiverse" >> /etc/apt/sources.list && echo "deb mirror://mirrors.ubuntu.com/mirrors.txt saucy-backports main restricted universe multiverse" >> /etc/apt/sources.list && echo "deb mirror://mirrors.ubuntu.com/mirrors.txt saucy-security main restricted universe multiverse" >> /etc/apt/sources.list

RUN apt-get update && apt-get install -qq php5-fpm php5-mysqlnd php5-json php5-gd php5-mcrypt 

RUN sed -i 's|listen.*=.*|listen=9000|' /etc/php5/fpm/pool.d/www.conf

RUN sed -i 's|#cgi.fix_pathinfo=1|cgi.fix_pathinfo=0|' /etc/php5/fpm/php.ini

ADD setmysqlip.sh /setmysqlip.sh

ADD setmysqlip_runphp.sh /setmysqlip_runphp.sh

ADD install_phpmyadmin.sh /install_phpmyadmin.sh

EXPOSE 9000

CMD ["sh","/setmysqlip_runphp.sh"]