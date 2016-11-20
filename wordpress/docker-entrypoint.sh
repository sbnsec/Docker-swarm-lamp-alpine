#!/bin/sh

cat > .htaccess <<-'EOF'
  # BEGIN WordPress
  <IfModule mod_rewrite.c>
  RewriteEngine On
  RewriteBase /
  RewriteRule ^index\.php$ - [L]
  RewriteCond %{REQUEST_FILENAME} !-f
  RewriteCond %{REQUEST_FILENAME} !-d
  RewriteRule . /index.php [L]
  </IfModule>
  # END WordPress
EOF
chown www-data:www-data .htaccess

# set apache as owner/group
chown -R apache:apache /app

echo "[i] Starting daemon..."
exec httpd -DFOREGROUND

chown -R apache:apache /app

echo "[i] Starting daemon..."
exec httpd -DFOREGROUND


