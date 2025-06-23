#!/bin/bash

# Configure PostgreSQL
sudo -u postgres psql -c "CREATE USER mirth WITH PASSWORD 'TsPmAsTeR@123';"
sudo -u postgres psql -c "CREATE DATABASE mirthdb OWNER mirth;"

# Install Mirth Connect
wget -O /tmp/mirthconnect-4.5.2.zip https://downloads.mirthconnect.com/mirthconnect-4.5.2-24892.zip
unzip /tmp/mirthconnect-4.5.2.zip -d /opt
mv "/opt/Mirth Connect" /opt/mirthconnect

# Configure Mirth Connect
cat > /opt/mirthconnect/conf/mirth.properties <<EOF
database = postgres
database.url = jdbc:postgresql://localhost:5432/mirthdb
database.username = mirth
database.password = TsPmAsTeR@123

api.initialadmin.username = tspmaster
api.initialadmin.password = TsPmAsTeR@123
EOF

# Create systemd service
cat > /etc/systemd/system/mirthconnect.service <<EOF
[Unit]
Description=Mirth Connect Service
After=network.target postgresql.target

[Service]
Type=simple
WorkingDirectory=/opt/mirthconnect
ExecStart=/opt/mirthconnect/mcservice start
Restart=always
User=mirth
Group=mirth

[Install]
WantedBy=multi-user.target
EOF

# Create Mirth user
useradd -m -s /bin/bash mirth
chown -R mirth:mirth /opt/mirthconnect
systemctl enable mirthconnect

# Install pgAdmin4
curl -fsS https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo gpg --dearmor -o /usr/share/keyrings/pgadmin-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/pgadmin-keyring.gpg] https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" | sudo tee /etc/apt/sources.list.d/pgadmin4.list
apt update
apt install -y pgadmin4-web

# Configure pgAdmin
sudo -u pgadmin /usr/pgadmin4/bin/setup-web.sh --setup-email tspmaster@example.com --setup-password TsPmAsTeR@123
sed -i 's/Listen 80/Listen 5050/' /etc/apache2/ports.conf
sed -i 's/<VirtualHost \*:80>/<VirtualHost \*:5050>/' /etc/apache2/sites-available/pgadmin4.conf
a2ensite pgadmin4
systemctl reload apache2

# Create pgAdmin server configuration
mkdir -p /var/lib/pgadmin/storage/tspmaster_example.com
cat > /var/lib/pgadmin/storage/tspmaster_example.com/servers.json <<EOF
{
  "Servers": {
    "1": {
      "Name": "Local MirthDB",
      "Group": "Servers",
      "Port": 5432,
      "Username": "mirth",
      "Host": "localhost",
      "SSLMode": "prefer",
      "MaintenanceDB": "postgres"
    }
  }
}
EOF
chown -R pgadmin:pgadmin /var/lib/pgadmin/storage/tspmaster_example.com

# Enable services
systemctl enable postgresql apache2
systemctl start mirthconnect