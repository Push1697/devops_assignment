#!/bin/bash
yum update -y
yum install -y nodejs npm

# Setup App Directory
mkdir -p /opt/app
cd /opt/app

# Write App Files
cat << 'APP_EOF' > package.json
${package_json}
APP_EOF

cat << 'APP_EOF' > server.js
${server_js}
APP_EOF

# Install and Start
npm install
npm start > app.log 2>&1 &
