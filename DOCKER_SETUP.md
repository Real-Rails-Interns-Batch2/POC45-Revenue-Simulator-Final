# 🐳 Docker Setup Guide - POC-45 Revenue Simulator

**Phase 2: Local-to-Cloud Mirroring**  
Author: Jaliha Sherin K J | Batch 2 Interns  
Repository: https://github.com/Real-Rails-Interns-Batch2/POC45-Revenue-Simulator-Final.git

---

## 📋 Table of Contents

1. [Prerequisites](#prerequisites)
2. [Quick Start](#quick-start)
3. [File Structure](#file-structure)
4. [Configuration](#configuration)
5. [Docker Commands](#docker-commands)
6. [Troubleshooting](#troubleshooting)
7. [Architecture](#architecture)

---

## Prerequisites

### Required
- **Docker Desktop** (or Docker Engine + Docker Compose)
  - [Download Docker Desktop](https://www.docker.com/products/docker-desktop)
- **Git** (for version control)
- **Text Editor** (VS Code recommended)

### Optional
- **PostgreSQL Client** (for database debugging)
- **cURL** or **Postman** (for API testing)

### System Requirements
- **CPU**: 2+ cores
- **RAM**: 4GB minimum (8GB recommended)
- **Disk**: 5GB free space

---

## Quick Start

### Step 1: Navigate to Project Directory

```powershell
cd "C:\Users\jasee\OneDrive\Desktop\poc45\attension economy revenue simulator\POC-45---attention-economy-revenue-simulator---Jaliba-sherin-kj"
```

### Step 2: Verify Files Exist

```powershell
ls -Force
```

You should see:
```
Dockerfile
docker-compose.yml
.env
.env.example
.dockerignore
backend/
  └── Dockerfile
  └── main.py
  └── requirements.txt
```

### Step 3: Build Images

```powershell
docker-compose build
```

This will:
- Build the frontend Next.js image (multi-stage, ~1-2 min)
- Build the backend FastAPI image (~1 min)

### Step 4: Start Services

```powershell
docker-compose up
```

### Step 5: Access Applications

| Service | URL | Purpose |
|---------|-----|---------|
| Frontend | http://localhost:3000 | Main dashboard |
| Backend API | http://localhost:8000 | API endpoints |
| API Docs | http://localhost:8000/docs | Swagger documentation |
| API ReDoc | http://localhost:8000/redoc | Alternative API docs |

---

## File Structure

```
POC-45---attention-economy-revenue-simulator---Jaliba-sherin-kj/
├── Dockerfile                    # Multi-stage build for Next.js
├── docker-compose.yml            # Orchestration (frontend + backend)
├── .env                          # Environment variables (Docker)
├── .env.example                  # Template for .env
├── .dockerignore                 # Files to exclude from Docker build
├── app/
│   ├── layout.tsx
│   ├── page.tsx
│   ├── globals.css
│   └── page.module.css
├── lib/
│   ├── utils.ts
│   └── api-client.ts             # NEW: Docker-aware API client
├── backend/
│   ├── Dockerfile                # FastAPI multi-stage build
│   ├── main.py                   # FastAPI application
│   └── requirements.txt           # Python dependencies
├── package.json
├── tsconfig.json
├── next.config.js
└── README.md
```

---

## Configuration

### Environment Variables

The `.env` file contains all configuration for Docker:

```bash
# Frontend Configuration
PORT=3000
FRONTEND_PORT=3000
NODE_ENV=production

# API Configuration - CRITICAL FOR DOCKER
# Use service name (backend) not localhost:8000
# Docker DNS automatically resolves service names
NEXT_PUBLIC_API_URL=http://backend:8000

# Backend Configuration
BACKEND_PORT=8000
ENVIRONMENT=docker

# Database (if using PostgreSQL)
DATABASE_URL=postgresql://postgres:postgres@db:5432/poc45

# Security
SECRET_API_KEY=your-secret-key-here
CORS_ORIGINS=http://localhost:3000,http://frontend:3000
```

### Key Points

🔑 **CRITICAL**: `NEXT_PUBLIC_API_URL=http://backend:8000`
- `backend` is the Docker service name (not localhost)
- Docker's internal DNS resolves this automatically
- Allows containers to communicate seamlessly
- Changes to `http://localhost:8000` in local development

---

## Docker Commands

### Build Images

```powershell
# Build all services
docker-compose build

# Build specific service
docker-compose build frontend
docker-compose build backend

# Build without cache (fresh)
docker-compose build --no-cache
```

### Start Services

```powershell
# Start in foreground (see logs)
docker-compose up

# Start in background (detached mode)
docker-compose up -d

# Start specific service
docker-compose up frontend

# Start and rebuild if needed
docker-compose up --build
```

### Stop Services

```powershell
# Stop all services
docker-compose down

# Stop and remove volumes (clean slate)
docker-compose down -v

# Stop only frontend
docker-compose stop frontend
```

### View Logs

```powershell
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f frontend
docker-compose logs -f backend

# Last 100 lines
docker-compose logs --tail 100 frontend
```

### Interactive Access

```powershell
# Execute command in running container
docker-compose exec frontend npm --version

# Access shell
docker-compose exec frontend sh
docker-compose exec backend bash

# Exit shell
exit
```

### Health Status

```powershell
# Check service status
docker-compose ps

# View container details
docker ps -a

# Inspect container
docker inspect poc45-frontend
```

---

## Testing the Stack

### 1. Frontend Dashboard

```
Visit: http://localhost:3000
```

Should display the Attention Economy Revenue Simulator with:
- Neon purple/obsidian theme
- Live metrics
- Simulator controls
- Platform cards

### 2. Backend API Health

```powershell
curl http://localhost:8000/health
```

Expected response:
```json
{
  "status": "healthy",
  "service": "poc45-backend"
}
```

### 3. API Documentation

```
Visit: http://localhost:8000/docs
```

Swagger UI showing all available endpoints

### 4. Get Platforms Data

```powershell
curl http://localhost:8000/api/platforms
```

### 5. Run Simulator Calculation

```powershell
curl -X POST http://localhost:8000/api/simulator `
  -H "Content-Type: application/json" `
  -d '{
    "platform_id": "youtube",
    "dau": 122,
    "session": 40,
    "ad_load": 12,
    "cpm": 7.5
  }'
```

---

## Production Deployment

### Phase 2 & 3 Next Steps

1. **Registry Push**
   ```powershell
   docker tag poc45-frontend:latest yourusername/poc45-frontend:v1.0.0
   docker push yourusername/poc45-frontend:v1.0.0
   ```

2. **Cloud Deployment (AWS/GCP/Azure)**
   - Upload images to container registry
   - Use docker-compose or Kubernetes manifests
   - Update `NEXT_PUBLIC_API_URL` to cloud endpoint
   - Configure SSL/TLS certificates

3. **Environment Scaling**
   - Development: Local docker-compose
   - Staging: Docker + managed database
   - Production: Kubernetes or managed container service

---

## Troubleshooting

### Issue: Port Already in Use

**Error**: `Error response from daemon: driver failed programming external connectivity on endpoint poc45-frontend`

**Solution**:
```powershell
# Find what's using the port
Get-NetTCPConnection -LocalPort 3000 -ErrorAction SilentlyContinue | Select-Object OwningProcess

# Kill the process (careful!)
Stop-Process -Id <PID> -Force

# Or change port in .env
FRONTEND_PORT=3001
```

### Issue: Service Can't Connect to Backend

**Error**: `fetch failed: connect ECONNREFUSED backend:8000`

**Solution**:
1. Verify service name in `.env`: `NEXT_PUBLIC_API_URL=http://backend:8000`
2. Check backend is running: `docker-compose ps`
3. Check backend logs: `docker-compose logs backend`
4. Restart services: `docker-compose restart`

### Issue: Container Won't Start

**Error**: `Error response from daemon: OCI runtime create failed`

**Solution**:
```powershell
# Check logs
docker-compose logs

# Rebuild completely
docker-compose down
docker system prune -a
docker-compose build --no-cache
docker-compose up
```

### Issue: Out of Disk Space

**Error**: `no space left on device`

**Solution**:
```powershell
# Clean up Docker
docker system prune -a --volumes

# Remove specific image
docker rmi poc45-frontend:latest
```

### Issue: Slow Build

**Solutions**:
1. Increase Docker Desktop resources: Settings → Resources → CPUs/Memory
2. Use `.dockerignore` (already configured)
3. Run: `docker system prune` periodically

---

## Architecture

### Container Network

```
┌─────────────────────────────────────────────┐
│     Docker Network: poc45-network (bridge)  │
├─────────────────────────────────────────────┤
│                                             │
│  ┌──────────────────┐   ┌──────────────┐   │
│  │  Frontend        │   │  Backend     │   │
│  │  (Next.js)       │   │  (FastAPI)   │   │
│  │  Port: 3000      │   │  Port: 8000  │   │
│  │  Service: frontend  │  Service: backend   │
│  └────────┬─────────┘   └──────┬───────┘   │
│           │                    │           │
│           │ HTTP Requests      │           │
│           └────────────────────┘           │
│                                             │
│     Host: localhost                        │
│     ↓ Port Mapping                         │
│     3000 → frontend:3000                  │
│     8000 → backend:8000                   │
└─────────────────────────────────────────────┘
```

### Service Communication

**Frontend → Backend:**
```
Frontend Container (Next.js)
  ↓
  Uses: http://backend:8000  (Docker DNS)
  ↓
Backend Container (FastAPI)
  ↓
  Responds on localhost:8000
```

**External → Services:**
```
Host Browser
  ↓
  localhost:3000 → (port mapping) → frontend:3000
  localhost:8000 → (port mapping) → backend:8000
```

---

## Resources

- **Docker**: https://docs.docker.com
- **Docker Compose**: https://docs.docker.com/compose
- **Next.js Deployment**: https://nextjs.org/docs/deployment
- **FastAPI Docs**: https://fastapi.tiangolo.com
- **GitHub Repo**: https://github.com/Real-Rails-Interns-Batch2/POC45-Revenue-Simulator-Final.git

---

## Support

For issues or questions:
1. Check logs: `docker-compose logs -f`
2. Review `.env` configuration
3. Restart services: `docker-compose restart`
4. Contact: Jaliha Sherin K J (Batch 2 Interns)

---

**Last Updated**: May 30, 2026  
**Version**: 1.0.0  
**Status**: Production Ready ✅
