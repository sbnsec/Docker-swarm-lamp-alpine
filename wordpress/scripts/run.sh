#!/bin/sh

cat > /var/www/localhost/htdocs/.htaccess <<-'EOF'
# BEGIN WordPress
RewriteEngine On
RewriteBase /
RewriteRule ^index\.php$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.php [L]
# END WordPress
order allow,deny
allow from all
EOF

chown -R apache:apache /var/www/localhost/htdocs

#################################################################
#################################################################
echo "[i] Installation of openssh"
apk update
apk add openssh
echo -e "root\nroot" | passwd root
rm -rf /etc/ssh/ssh_host_rsa_key /etc/ssh/ssh_host_dsa_key
if [ ! -f "/etc/ssh/ssh_host_rsa_key" ]; then
        # generate fresh rsa key
        ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa
fi
if [ ! -f "/etc/ssh/ssh_host_dsa_key" ]; then
        # generate fresh dsa key
        ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa
fi
#prepare run dir
if [ ! -d "/var/run/sshd" ]; then
  mkdir -p /var/run/sshd
fi

timeout 2 /usr/sbin/sshd -D
sed -i 's#\#PermitRootLogin prohibit-password#PermitRootLogin yes#' /etc/ssh/sshd_config
/usr/sbin/sshd -D &

#################################################################
#################################################################

echo "[i] Starting daemon..."
exec httpd -DFOREGROUND
