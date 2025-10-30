#!/usr/bin/env bash
set -euo pipefail
apt update -y
apt install -y docker.io docker-compose-plugin nginx certbot python3-certbot-nginx git
systemctl enable --now docker
if [ -f backend/.env.example ] && [ ! -f backend/.env ]; then cp backend/.env.example backend/.env; fi
if [ -f frontend/.env.example ] && [ ! -f frontend/.env ]; then cp frontend/.env.example frontend/.env; fi
docker compose up -d --build
if [ -f nginx/kitaclick.conf ]; then
  cp nginx/kitaclick.conf /etc/nginx/sites-available/kitaclick
  ln -sf /etc/nginx/sites-available/kitaclick /etc/nginx/sites-enabled/kitaclick
  nginx -t && systemctl reload nginx || true
  certbot --nginx -n --agree-tos --redirect -m you@yourdomain.com -d kitaclick.online -d www.kitaclick.online -d api.kitaclick.online || true
fi
echo "Deployed"
