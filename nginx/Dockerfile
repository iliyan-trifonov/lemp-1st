FROM ubuntu:13.10

RUN echo "deb mirror://mirrors.ubuntu.com/mirrors.txt saucy main restricted universe multiverse" > /etc/apt/sources.list && echo "deb mirror://mirrors.ubuntu.com/mirrors.txt saucy-updates main restricted universe multiverse" >> /etc/apt/sources.list && echo "deb mirror://mirrors.ubuntu.com/mirrors.txt saucy-backports main restricted universe multiverse" >> /etc/apt/sources.list && echo "deb mirror://mirrors.ubuntu.com/mirrors.txt saucy-security main restricted universe multiverse" >> /etc/apt/sources.list

RUN apt-get update && apt-get install -qq nginx-full

RUN NGINXCONFFILE=/etc/nginx/nginx.conf && echo "daemon off;" | cat - $NGINXCONFFILE > $NGINXCONFFILE.tmp && mv $NGINXCONFFILE.tmp $NGINXCONFFILE

ADD serverconfigs/default /etc/nginx/sites-enabled/default

ADD index.php /tmp/index.php
ADD phpinfo.php /tmp/phpinfo.php

ADD setphpip.sh /setphpip.sh

ADD setphpip_runnginx.sh /setphpip_runnginx.sh

CMD ["sh","/setphpip_runnginx.sh"]