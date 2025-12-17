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


docker run -d \
  --name n8n \
  -p 5678:5678 \
  -e N8N_HOST=0.0.0.0 \
  -e N8N_PORT=5678 \
  -e N8N_PROTOCOL=http \
  -e N8N_BASIC_AUTH_ACTIVE=false \
  -v /opt/n8n:/home/node/.n8n \
  -e GENERIC_TIMEZONE=Asia/Kolkata \
  --restart unless-stopped \
  n8nio/n8n