#!/bin/bash

echo "user_data" > /var/lib/cloud/instance/sem/config_scripts_user

exec > >(tee /var/log/userdata.log|logger -t userdata) 2>&1

echo "Starting user data script..."

# Update and install Docker on AL2023
sudo dnf update -y
sudo dnf install docker -y

sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker ec2-user

# Pull Backend Image
sudo docker pull ${backend_image}
sudo docker stop employee-backend || true
sudo docker rm employee-backend || true
sudo docker run -d \
  --name employee-backend \
  -p 8080:8080 \
  -e SPRING_DATASOURCE_URL="jdbc:mysql://${db_host}:${db_port}/${db_name}" \
  -e SPRING_DATASOURCE_USERNAME="${db_user}" \
  -e SPRING_DATASOURCE_PASSWORD="${db_password}" \
  --restart=always \
  ${backend_image}

sudo docker pull ghcr.io/manikanta0802/employee-frontend:5
sudo docker stop employee-frontend || true
sudo docker rm employee-frontend || true

# Pull Frontend Image
sudo docker pull ${frontend_image}
sudo docker stop employee-frontend || true
sudo docker rm employee-frontend || true
sudo docker run -d \
  --name employee-frontend \
  -p 80:80 \
  --restart=always \
  ${frontend_image}

echo "Finished user data script!"
