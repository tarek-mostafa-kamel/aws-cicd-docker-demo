#!/bin/bash
set -euxo pipefail

apt-get update -y
apt-get install -y docker.io docker-compose-v2 git curl
systemctl enable --now docker
usermod -aG docker ubuntu

sudo -u ubuntu git clone ${repo_url} /home/ubuntu/app

GIT_SHA=$(sudo -u ubuntu git -C /home/ubuntu/app rev-parse --short HEAD)
BUILD_TIME=$(date -u +"%Y-%m-%d %H:%M UTC")
export GIT_SHA BUILD_TIME

cd /home/ubuntu/app
docker compose up -d --build
