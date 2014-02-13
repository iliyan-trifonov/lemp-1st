Docker LEMP Stack
===
### 5 Containers, 2 for data, 3 for nginx/php/mysql. Custom MySQL datadir. Only the webserver port 8080 is open, all containers use linking between them.

Tested under Ubuntu 12.04/12.10 and CoreOS in Virtualbox or installed on a physical server with Docker version 0.8.0.

These scripts create a development environment but with a few security tweaks you can put it in production.

Check [docker.io](http://docker.io "Docker official") for more information about this great revolutionary  app!

#### [Click here for a video showing the installation of the containers from this project.](https://asciinema.org/a/7594)

## 1st: The interesting stuff
Using the -link and -expose params is one of the best features I've found with Docker and so I used them everywhere!

Of course I wanted to make everything as suggested in the docs so I used data volumes too:
one for the MySQL data dir and one for the web pages.

The IPs of the PHP Server and MySQL Server are taken from the environment vars (`env`) and updated when the containers
that use them are started with no custom CMD:

`/etc/nginx/sites-enabled/default` is updated with the IP of the container that runs the php5-fpm.

`/sites/mysqlserverip.php` is updated when the PHP Server Container is started and this file is included and used in the
php scripts that have to communicate with the MySQL Server. The php file  just defines the `MYSQLSERVERADDR` php constant.

`phpMyAdmin-4.1.7-all-languages` package is downloaded automatically and configured with the right server IP
in the place of `localhost` again using the /sites/mysqlserverip.php file from above.

If you run MySQL inside a container like this: `/usr/bin/mysqld_safe &`
you will have to use `mysqladmin -uroot -h127.0.0.1 --protocol=tcp shutdown` to stop it instead of killing it

If Ctrl-c and Ctrl-z don't work, try using Ctrl-\ to stop a program running in the foreground.
If nothing is working, just kill/stop/start/run the container again.

If you want to change something inside a container and re-run it, use attach if possible or run the image with CMD bash,
make your changes, run the server process and detach with Ctrl-p + Ctrl-q. From here you can commit the container with a
new tag or name and re-run it with the new configuration automatically set.

You can start/stop/rm/run any of the 3 running containers and the links between them are not lost. the IPs stay the same
too.

For access from the container to the host, find the host's ip with ifconfig/docker inspect or use its public address.
Then install and use `scp`, `nano`, etc.

For example, I used the MySQL container in a master-master replication with the host's MySQL server:

- `kill` & `rm` the `mysqlserver1` container
- run a new one with `bash` as CMD
- `scp` from the host's backup dir to the container's temporary one
- edit `/etc/mysql/my.cnf` and put the needed configuration
- import of the DBs in the container
- then use `http://localhost:8080/phpmyadmin/` to configure the replication settings of the container's MySQL server.
- restart the container's MySQL server and detach.

If you want to put this in production, take care of some things: the MySQL server is very open so it needs some users
to be removed and some created with restriction to specific container IP and good passwords.

### How to use it (Ubuntu example):

The main requirement is to have Docker installed and running on your system. See the section below about
installing it under Ubuntu.

Also you need to have the curl and git packages installed:

`sudo apt-get update && sudo apt-get install -qq curl git`

Get the latest build script from GitHub:

`git clone https://github.com/iliyan-trifonov/docker-lemp-1st.git`

Go inside the directory

`cd docker-lemp-1st`

Run the build_all shell script:

`sh build_all.sh`

Or if you already executed the build once:

`sh rerun_all.sh`

The above script will kill and remove all containers and images created by the build script and run the build again.

That's it! You now have 3 running containers using 2 data volumes.
Use `http://localhost:8080` to connect to the root of the web server and `http://localhost:8080/phpmyadmin/` to manage the MySQL DB (user and pass: docker/docker).

### Install lxc Docker under Ubuntu 12.04:

Skip this if you have deb sources hosted on the local network for example: on your hosting provider.

Before installing anything make sure you use the fastest deb sources:

sudo echo "deb mirror://mirrors.ubuntu.com/mirrors.txt precise main restricted universe multiverse" > /etc/apt/sources.list<br>
sudo echo "deb mirror://mirrors.ubuntu.com/mirrors.txt precise-updates main restricted universe multiverse" >> /etc/apt/sources.list<br>
sudo echo "deb mirror://mirrors.ubuntu.com/mirrors.txt precise-backports main restricted universe multiverse" >> /etc/apt/sources.list<br>
sudo echo "deb mirror://mirrors.ubuntu.com/mirrors.txt precise-security main restricted universe multiverse" >> /etc/apt/sources.list<br>

You may need the latest kernel installed and running on your system to fulfill Docker's and LXC requirements
(you are probably ok without `&& sudo grub-update`):

`sudo apt-get update && sudo apt-get install -qq linux-generic-lts-raring curl && sudo grub-update && sudo reboot`

It may not work just with the install and update so make sure you get it running by looking into grub's configuration.

And then install Docker:

`curl get.docker.io | sudo sh -x`

After Docker is installed add your user to the docker group to not need to be root for every `docker ...` command:

`sudo usermod -aG docker your-user`

And then re-login into your user

Check if Docker is installed and running fine by using one of its commands:

`docker version`

This should show various version statistics and should not produce any errors.
You are now ready to use Docker and have the world!

## What to do with these containers from now on:
Build one that will provide ssh/sftp/ftp access to all of them, especially the data volumes for web sites upload/download.

Build more containers from the same images and try configuring and using replication and load balancing on them.

Use different SQL and No-SQL databases in another containers and link them to the existing ones.

Create another host with docker somewhere else and link securely the containers from one host to another.

