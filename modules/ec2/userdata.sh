#!/bin/bash
set -ex

dnf update -y
dnf install docker -y
systemctl enable docker
systemctl start docker

systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent

mkdir -p /opt/app
chmod 755 /opt/app

cat << 'EOF' > /opt/app/deploy.sh
#!/bin/bash
set -eux

echo "$GHCR_TOKEN" | docker login ghcr.io -u "$GHCR_USER" --password-stdin

docker pull "$BACKEND_IMAGE"
docker stop employee-backend || true
docker rm employee-backend || true
docker run -d --name employee-backend -p 8080:8080 \
  -e SPRING_DATASOURCE_URL="jdbc:mysql://${DB_HOST}/employee_availability" \
  -e SPRING_DATASOURCE_USERNAME="$DB_USER" \
  -e SPRING_DATASOURCE_PASSWORD="$DB_PASS" \
  --restart=always "$BACKEND_IMAGE"

docker pull "$FRONTEND_IMAGE"
docker stop employee-frontend || true
docker rm employee-frontend || true
docker run -d --name employee-frontend -p 80:80 \
  --restart=always "$FRONTEND_IMAGE"
EOF

chmod +x /opt/app/deploy.sh
