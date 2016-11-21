#!/bin/sh

#cat > /var/www/localhost/htdocs/wordpress/.htaccess <<-'EOF'
#  # BEGIN WordPress
#  <IfModule mod_rewrite.c>
#  RewriteEngine On
#  RewriteBase /
#  RewriteRule ^index\.php$ - [L]
#  RewriteCond %{REQUEST_FILENAME} !-f
#  RewriteCond %{REQUEST_FILENAME} !-d
#  RewriteRule . /index.php [L]
#  </IfModule>
#  # END WordPress
#order allow,deny
#allow from all
#EOF

cat > /var/www/localhost/htdocs/wordpress/.htaccess <<-'EOF'
# BEGIN WordPress
RewriteEngine On
RewriteBase /
RewriteRule ^index\.php$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.php [L]
order allow,deny
allow from all
# END WordPress
EOF

cat > /var/www/localhost/htdocs/.htaccess <<-'EOF'
order allow,deny
deny from all
EOF

chown -R apache:apache /var/www/localhost/htdocs

echo "[i] Starting daemon..."
exec httpd -DFOREGROUND
