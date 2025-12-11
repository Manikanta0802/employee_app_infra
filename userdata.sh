#!/bin/bash
#testing
echo "user_data" > /var/lib/cloud/instance/sem/config_scripts_user

yum update -y

# Install Docker
amazon-linux-extras install docker -y
systemctl enable docker
systemctl start docker
usermod -aG docker ec2-user

# Backend
docker pull ghcr.io/manikanta0802/employee-backend:5
docker stop employee-backend || true
docker rm employee-backend || true
docker run -d \
  --name employee-backend \
  -p 8080:8080 \
  -e SPRING_DATASOURCE_URL="jdbc:mysql://${db_host}:${db_port}/${db_name}" \
  -e SPRING_DATASOURCE_USERNAME="${db_user}" \
  -e SPRING_DATASOURCE_PASSWORD="${db_password}" \
  --restart=always \
  ${backend_image}

# Frontend
docker pull  ghcr.io/manikanta0802/employee-frontend:5
docker stop employee-frontend || true
docker rm employee-frontend || true
docker run -d \
  --name employee-frontend \
  -p 80:80 \
  --restart=always \
  ${frontend_image}
