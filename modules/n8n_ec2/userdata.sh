#!/bin/bash
set -ex

# Update system
yum update -y

# Install Docker
yum install -y docker
systemctl start docker
systemctl enable docker

# Create n8n data directory
mkdir -p /opt/n8n

# n8n runs as UID 1000 inside container
chown -R 1000:1000 /opt/n8n
chmod -R u+rwX,g+rwX /opt/n8n

docker run -d \
--name n8n \
--user 1000:1000 \
-p 5678:5678 \
-v /opt/n8n:/home/node/.n8n \
-e N8N_HOST=0.0.0.0 \
-e N8N_PORT=5678 \
-e N8N_PROTOCOL=http \
-e N8N_BASIC_AUTH_ACTIVE=false \
-e N8N_SECURE_COOKIE=false \
--restart unless-stopped \
n8nio/n8n