#!/bin/bash
# Author: Yevgeniy Goncharov aka xck, http://sys-adm.in
# Script for install pgAdmin to CentOS
#

# Sys env / paths / etc
# -------------------------------------------------------------------------------------------\
PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
SCRIPT_PATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)

HTTPD_PORT="81"

# Installation steps
# -------------------------------------------------------------------------------------------\
yum -y install epel-release
yum -y install https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
yum -y install pgadmin4

# HTTPD port binding
sed -i 's/^Listen.*/Listen $HTTPD_PORT/' /etc/httpd/conf/httpd.conf
mv /etc/httpd/conf.d/pgadmin4.conf.sample /etc/httpd/conf.d/pgadmin4.conf

mkdir -p /var/lib/pgadmin4/ /var/log/pgadmin4/

cat > /usr/lib/python3.6/site-packages/pgadmin4-web/config_distro.py <<_EOF_
LOG_FILE = '/var/log/pgadmin4/pgadmin4.log'
SQLITE_PATH = '/var/lib/pgadmin4/pgadmin4.db'
SESSION_DB_PATH = '/var/lib/pgadmin4/sessions'
STORAGE_DIR = '/var/lib/pgadmin4/storage'
_EOF_

# Setup
python3 /usr/lib/python3.6/site-packages/pgadmin4-web/setup.py

# Set permissions
chown -R apache:apache /var/lib/pgadmin4 /var/log/pgadmin4

# SELinux
semanage fcontext -a -t httpd_sys_rw_content_t "/var/lib/pgadmin4(/.*)?"
semanage fcontext -a -t httpd_sys_rw_content_t "/var/log/pgadmin4(/.*)?"
restorecon -R /var/lib/pgadmin4/
restorecon -R /var/log/pgadmin4/

# Enable and run HTTPD
systemctl enable --now httpd

# Allow port
firewall-cmd --permanent --add-port=$HTTPD_PORT/tcp
firewall-cmd --reload

SERVER_IP=$(hostname -I | cut -d' ' -f1)

echo "http://$SERVER_IP:$HTTPD_PORT/pgadmin4"
echo "You can test you installation with command:"
echo -e "curl \"http://$SERVER_IP:$HTTPD_PORT/pgadmin4/login?next=%2Fpgadmin4%2F\""
