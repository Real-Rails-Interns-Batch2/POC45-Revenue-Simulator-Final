# ─────────────────────────────────────────────────────────────────────
# QUICK START SCRIPT - POC-45 Docker Setup
# Phase 2: Local-to-Cloud Mirroring
# Author: Jaliha Sherin K J | Batch 2 Interns
#
# Usage: 
#   .\docker-quickstart.ps1 up      # Start services
#   .\docker-quickstart.ps1 down    # Stop services
#   .\docker-quickstart.ps1 logs    # View logs
#   .\docker-quickstart.ps1 clean   # Clean everything
# ─────────────────────────────────────────────────────────────────────

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet('up', 'down', 'logs', 'restart', 'clean', 'build', 'status')]
    [string]$Command = 'up'
)

# Color output
function Write-Header {
    Write-Host "`n╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║  POC-45 Revenue Simulator - Docker Quick Start" -ForegroundColor Cyan
    Write-Host "║  Author: Jaliha Sherin K J | Batch 2 Interns" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan
}

function Write-Success {
    param([string]$Message)
    Write-Host "✓ $Message" -ForegroundColor Green
}

function Write-Error-Message {
    param([string]$Message)
    Write-Host "✗ $Message" -ForegroundColor Red
}

function Write-Info {
    param([string]$Message)
    Write-Host "ℹ $Message" -ForegroundColor Yellow
}

# Check if Docker is installed
function Check-Docker {
    try {
        $version = docker --version
        Write-Success "Docker found: $version"
        return $true
    }
    catch {
        Write-Error-Message "Docker is not installed or not in PATH"
        Write-Info "Download Docker Desktop: https://www.docker.com/products/docker-desktop"
        exit 1
    }
}

# Main commands
function Start-Services {
    Write-Info "Starting services with docker-compose..."
    docker-compose up
}

function Stop-Services {
    Write-Info "Stopping services..."
    docker-compose down
    Write-Success "Services stopped"
}

function View-Logs {
    Write-Info "Showing logs (Ctrl+C to exit)..."
    docker-compose logs -f
}

function Restart-Services {
    Write-Info "Restarting services..."
    docker-compose restart
    Write-Success "Services restarted"
}

function Clean-Everything {
    Write-Error-Message "This will remove all containers, volumes, and images"
    $confirm = Read-Host "Continue? (yes/no)"
    
    if ($confirm -eq 'yes') {
        Write-Info "Stopping services..."
        docker-compose down -v
        
        Write-Info "Pruning Docker system..."
        docker system prune -a --volumes -f
        
        Write-Success "Cleanup complete"
    }
    else {
        Write-Info "Cleanup cancelled"
    }
}

function Build-Images {
    Write-Info "Building Docker images..."
    docker-compose build
    Write-Success "Build complete"
}

function Show-Status {
    Write-Info "Service Status:"
    Write-Host ""
    docker-compose ps
    Write-Host ""
    Write-Info "Access Points:"
    Write-Host "  Frontend:     http://localhost:3000" -ForegroundColor Cyan
    Write-Host "  Backend API:  http://localhost:8000" -ForegroundColor Cyan
    Write-Host "  API Docs:     http://localhost:8000/docs" -ForegroundColor Cyan
    Write-Host ""
}

# Main execution
Write-Header
Check-Docker

switch ($Command) {
    'up' {
        Start-Services
    }
    'down' {
        Stop-Services
    }
    'logs' {
        View-Logs
    }
    'restart' {
        Restart-Services
    }
    'clean' {
        Clean-Everything
    }
    'build' {
        Build-Images
    }
    'status' {
        Show-Status
    }
    default {
        Start-Services
    }
}

Write-Host ""
