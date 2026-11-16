#!/usr/bin/env bash
# Run once on a fresh Ubuntu 22.04/24.04 EC2 instance.
# Usage: bash setup-ec2.sh https://github.com/<you>/<repo>.git
set -euo pipefail
REPO_URL="${1:?Pass your GitHub repo URL as the first argument}"

sudo apt-get update -y
sudo apt-get install -y docker.io docker-compose-v2 git curl
sudo systemctl enable --now docker
sudo usermod -aG docker "$USER"

git clone "$REPO_URL" ~/app
cd ~/app
export GIT_SHA=$(git rev-parse --short HEAD)
export BUILD_TIME=$(date -u +"%Y-%m-%d %H:%M UTC")
sudo -E docker compose up -d --build
echo "Done. Open http://<EC2-PUBLIC-IP>/ in your browser."
echo "Log out and back in so the docker group applies to your user."
