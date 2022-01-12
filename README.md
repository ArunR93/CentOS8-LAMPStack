https://hub.docker.com/r/rakarun93/centos-8-lampstack

## A CentOS 8 Image with LAMP and PHPMYAdmin

This docker contain a LAMP stack installed from scratch

## Installation
### Grab from docker hub
```
docker run -d -v /path/to/project:/var/www/html/ -v /path/to/database:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=password -p 80:80 -p 3306:3306 --name lamp rakarun93/centos-8-lampstack:v1
```


### PHPMY Admin Page

Open browser and enter the URL
http://localhost/Admin

### Connect to MariaDB
To use this you need to install mysql/mariadb cli client
```
mysql -uroot -ppassword -h 127.0.0.1
```



https://hub.docker.com/r/rakarun93/centos-8-lampstack
