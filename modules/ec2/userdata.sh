#!/bin/bash
set -eux
exec > >(tee /var/log/userdata.log|logger -t userdata) 2>&1

echo "Starting user data script..."

# Update and install Docker on AL2023
sudo dnf update -y
sudo dnf install docker -y

sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker ec2-user

# Ensure SSM Agent is installed (Amazon Linux 2023 already has it)
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent

# Create App Directory
mkdir -p /opt/app
chmod 755 /opt/app

# Creating the deploy.sh script
cat << 'EOF' > /opt/app/deploy.sh
#!/bin/bash
set -eux

echo "Starting Deployment at $(date)"

echo "Logging into GHCR..."
echo "$GHCR_TOKEN" | docker login ghcr.io -u "$GHCR_USER" --password-stdin

echo "Pulling backend image..."
docker pull "$BACKEND_IMAGE"
docker stop employee-backend || true
docker rm employee-backend || true

docker run -d \
  --name employee-backend \
  -p 8080:8080 \
  -e SPRING_DATASOURCE_URL="jdbc:mysql://${DB_HOST}/employee_availability" \
  -e SPRING_DATASOURCE_USERNAME="${DB_USER}" \
  -e SPRING_DATASOURCE_PASSWORD="${DB_PASS}" \
  --restart=always \
  "$BACKEND_IMAGE"

echo "Pulling frontend image..."
docker pull "$FRONTEND_IMAGE"
docker stop employee-frontend || true
docker rm employee-frontend || true

docker run -d \
  --name employee-frontend \
  -p 80:80 \
  --restart=always \
  "$FRONTEND_IMAGE"

echo "Deployment completed at $(date)"
EOF

# Make deploy script executable
chmod +x /opt/app/deploy.sh

echo "User-data completed successfully"