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

# Run n8n
docker run -d \
  --name n8n \
  -p 5678:5678 \
  -v /opt/n8n:/home/node/.n8n \
  -e N8N_BASIC_AUTH_ACTIVE=false \
  --restart unless-stopped \
  n8nio/n8n
