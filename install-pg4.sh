#!/bin/bash
# Author: Yevgeniy Goncharov aka xck, http://sys-adm.in
# Script for install pgAdmin to CentOS
#

# Sys env / paths / etc
# -------------------------------------------------------------------------------------------\
PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
SCRIPT_PATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)

HTTPD_PORT="81"
SERVER_IP=$(hostname -I | cut -d' ' -f1)

# Installation steps
# -------------------------------------------------------------------------------------------\
yum -y install epel-release policycoreutils-devel
yum -y install https://ftp.postgresql.org/pub/pgadmin/pgadmin4/yum/pgadmin4-redhat-repo-1-1.noarch.rpm
yum -y install pgadmin4-web

sed -i 's/^Listen.*/Listen '"$HTTPD_PORT"'/' /etc/httpd/conf/httpd.conf

# Enable and run HTTPD
systemctl enable httpd

# Allow port
firewall-cmd --permanent --add-port=$HTTPD_PORT/tcp
firewall-cmd --reload

# Setup pgAdmin
/usr/pgadmin4/bin/setup-web.sh

# User notice
echo -e "\nhttp://$SERVER_IP:$HTTPD_PORT/pgadmin4"
echo "You can test you installation with command:"
echo -e "curl \"http://$SERVER_IP:$HTTPD_PORT/pgadmin4/login?next=%2Fpgadmin4%2F\""

