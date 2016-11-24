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

echo "[i] Starting daemon..."
exec httpd -DFOREGROUND
