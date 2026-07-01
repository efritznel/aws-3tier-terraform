#!/bin/bash
yum install -y httpd

chown -R apache:apache /var/www/html
chmod -R 755 /var/www/html

echo "Project: High Availability 3-Tier Web Application on AWS" > /var/www/html/index.html

cat <<EOT > /etc/httpd/conf.d/allow-all.conf
<Directory "/var/www/html">
    AllowOverride None
    Require all granted
</Directory>
EOT

systemctl enable httpd
systemctl start httpd
