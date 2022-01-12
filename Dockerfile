FROM centos:centos8.4.2105
ENV TIMEZONE Asia/Kolkata
LABEL AUTHOR=arun \ 
	EMAIL=rakarun93@gmail.com

# LAMP Installation  Apache and MySQL dir

RUN dnf install epel-release-8  redhat-release  wget unzip -y \
	&& rpm -Uvh http://rpms.remirepo.net/enterprise/remi-release-8.rpm \
	&& dnf module enable php:remi-7.4 -y \ 
	&& dnf install -y php php-xml php-soap php-cli php-xmlrpc \
	php-mbstring php-pdo php-json php-gd php-mcrypt php-mysql php-fileinfo \
        php-zip  php-curl php-ldap php-intl php-sodium --exclude=php-fpm \
        && dnf erase -y php-fpm \
        && wget https://downloads.mariadb.com/MariaDB/mariadb_repo_setup -O /tmp/mariadb_repo_setup \ 
	&& chmod +x /tmp/mariadb_repo_setup \
	&& /tmp/./mariadb_repo_setup  \
	&& dnf -y install MariaDB-server MariaDB-backup \
	&& curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer \
	&& mkdir -p /var/run/mariadb/ && chown -R mysql:mysql /var/run/mariadb/ /var/lib/mysql && \
   	 mkdir -p /var/run/httpd/ && chown -R apache:apache /var/run/httpd/ && chown -R apache:apache /var/www/html/ && \
    	sed -i 's#\#LoadModule rewrite_module modules\/mod_rewrite.so#LoadModule rewrite_module modules\/mod_rewrite.so#' /etc/httpd/conf/httpd.conf && \
    	sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/my.cnf.d/server.cnf && \
    	sed -i "s#\#LoadModule mpm_prefork_module modules/mod_mpm_prefork.so#LoadModule mpm_prefork_module modules/mod_mpm_prefork.so#" /etc/httpd/conf.modules.d/00-mpm.conf && \
    	sed -i "s#\LoadModule mpm_event_module modules/mod_mpm_event.so#\#LoadModule mpm_event_module modules/mod_mpm_event.so#" /etc/httpd/conf.modules.d/00-mpm.conf && \
    	wget https://files.phpmyadmin.net/phpMyAdmin/5.1.0-rc1/phpMyAdmin-5.1.0-rc1-all-languages.zip -O /usr/share/phpMyAdmin.zip \
   	 && cd /usr/share  &&  unzip phpMyAdmin.zip \ 
    	&& mv phpMyAdmin-5.1.0-rc1-all-languages  phpMyAdmin		 \
    	&& chown -Rv apache:apache phpMyAdmin \
    	&& rm -rf phpMyAdmin.zip \
    	&& rm -rf /var/cache/dnf/ \
    	&& rm -rf /var/lib/dnf \
    	&& rm -rf /var/lib/rpm/
	
# PHP and Scripts
COPY entry.sh /entry.sh
COPY phpMyAdmin.conf /etc/httpd/conf.d/phpMyAdmin.conf
RUN chmod u+x /entry.sh
VOLUME /var/lib/mysql
VOLUME /var/www/html
WORKDIR /var/www/html
EXPOSE 80 3306
ENTRYPOINT ["/entry.sh"]
