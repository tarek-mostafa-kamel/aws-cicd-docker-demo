# AWS EC2 + Docker + Nginx + GitHub Actions CI/CD

A small static site served by Nginx inside Docker on AWS EC2.
Every push to `main` is built, smoke-tested, and deployed automatically.

## Architecture

```
git push -> GitHub Actions
              |- test:   docker build + run + curl /healthz
              |- deploy: SSH to EC2 -> git pull -> docker compose up -d --build
                                                        |
                                    EC2 (Ubuntu) -> Docker -> Nginx :80
```

## What is in the repo

| Path | Purpose |
|------|---------|
| `Dockerfile` | Nginx Alpine image, injects commit SHA and build time into the page |
| `nginx.conf` | Security headers, gzip, `/healthz` endpoint, hidden server version |
| `docker-compose.yml` | Runs the container with `restart: unless-stopped` |
| `.github/workflows/deploy.yml` | CI (build + smoke test) and CD (SSH deploy) |
| `scripts/setup-ec2.sh` | One-time server bootstrap |

## Setup

1. **Launch EC2**: Ubuntu 22.04/24.04, `t2.micro` or `t3.micro` (free tier eligible).
   Security Group inbound: SSH 22 from **your IP only**, HTTP 80 and HTTPS 443 from anywhere.
2. **Bootstrap the server**:
   ```bash
   ssh -i key.pem ubuntu@<EC2-PUBLIC-IP>
   curl -O https://raw.githubusercontent.com/<you>/<repo>/main/scripts/setup-ec2.sh
   bash setup-ec2.sh https://github.com/<you>/<repo>.git
   ```
   For a private repo, add a read-only deploy key on the server first.
3. **Add GitHub secrets** (Repo > Settings > Secrets and variables > Actions):
   - `EC2_HOST`: public IP or domain
   - `EC2_USER`: `ubuntu`
   - `EC2_SSH_KEY`: full contents of the private key (`.pem`)
4. **Push a change** to `main`. Watch the Actions tab, then refresh the site: the commit SHA changes.

## Optional: domain + free SSL

Point an A record at the EC2 IP, then on the server:
```bash
sudo apt-get install -y certbot
sudo docker compose down
sudo certbot certonly --standalone -d your-domain.com
```
Then mount `/etc/letsencrypt` into the container and add a `listen 443 ssl` block to `nginx.conf`.

## Hardening ideas

- Restrict SSH to your IP, use key-only auth, disable password login
- Use an Elastic IP so the address survives restarts
- Add CloudWatch alarms for CPU and status checks
- Move image builds to GitHub Actions + ECR for faster deploys
