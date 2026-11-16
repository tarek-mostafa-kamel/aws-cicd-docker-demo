# AWS EC2 + Docker + Nginx + GitHub Actions CI/CD

A small web app served by Nginx inside Docker on AWS EC2.
Every push to `main` is built, smoke-tested, and deployed automatically.

## Architecture

git push -> GitHub Actions
              |- test:   docker build + run + curl /healthz
              |- deploy: SSH to EC2 -> git pull -> docker compose up -d --build
                                                        |
                                    EC2 (Ubuntu) -> Docker -> Nginx :80

## Stack

AWS EC2, Ubuntu Linux, Docker, Docker Compose, Nginx, GitHub Actions, Bash

## What is in the repo

| Path | Purpose |
|------|---------|
| `Dockerfile` | Nginx Alpine image, injects commit SHA and build time into the page |
| `nginx.conf` | Security headers, gzip, `/healthz` endpoint, hidden server version |
| `docker-compose.yml` | Runs the container with `restart: unless-stopped` |
| `.github/workflows/deploy.yml` | CI (build + smoke test) and CD (SSH deploy) |
| `scripts/setup-ec2.sh` | One-time server bootstrap |

## How it works

1. A push to `main` triggers the workflow.
2. The **test** job builds the image, runs it, and checks `/healthz` and the home page.
3. If the tests pass, the **deploy** job connects to EC2 over SSH, pulls the latest code, and rebuilds the container.
4. The page shows the deployed commit SHA, so you can verify the new version is live.

## Setup

1. **Launch EC2:** Ubuntu 22.04/24.04, `t2.micro` or `t3.micro`.
   Security Group inbound: SSH (22) from your IP only, HTTP (80) and HTTPS (443) from anywhere.
2. **Bootstrap the server:**
   ```bash
   ssh -i key.pem ubuntu@<EC2-PUBLIC-IP>
   curl -O https://raw.githubusercontent.com/<you>/aws-cicd-docker-demo/main/scripts/setup-ec2.sh
   bash setup-ec2.sh https://github.com/<you>/aws-cicd-docker-demo.git
   ```
3. **Add GitHub secrets** (Settings > Secrets and variables > Actions):
   - `EC2_HOST`: public IP or domain
   - `EC2_USER`: `ubuntu`
   - `EC2_SSH_KEY`: contents of the private key
4. **Push a change** to `main` and watch the Actions tab.

## Security notes

- SSH restricted to a single IP in the Security Group
- Key-based authentication only
- Nginx version hidden, basic security headers enabled
- No credentials stored in the repo (GitHub Secrets only)

## Results

<!-- Add screenshots here after your first successful deploy -->
- Green pipeline in GitHub Actions: `docs/pipeline.png`
- Live page on EC2: `docs/live.png`

## Possible improvements

- Domain + free SSL with Let's Encrypt
- Elastic IP and CloudWatch alarms
- Build images in CI and push to ECR instead of building on the server
