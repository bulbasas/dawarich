# 🕐 Timeline Feature Deployment Guide

This guide explains how to deploy the Timeline feature to your Docker-based Dawarich installation.

## 📋 Prerequisites

- Docker and Docker Compose installed
- Running Dawarich instance (official `freikin/dawarich:latest` or custom)
- This repository cloned with the timeline feature branch

## 🚀 Quick Deployment (Recommended)

Use the automated deployment script:

```bash
# From the dawarich root directory
./docker/deploy-timeline.sh
```

This script will:
1. ✅ Build a new Docker image with the timeline feature
2. ✅ Stop existing containers
3. ✅ Start containers with the new image
4. ✅ Show status and access information

## 📝 Manual Deployment

If you prefer manual control:

### 1. Build the Docker Image

```bash
# From the dawarich root directory
docker build -f docker/Dockerfile -t dawarich-timeline:latest .
```

### 2. Stop Existing Containers

```bash
cd docker
docker-compose down
```

### 3. Use the Local Image Configuration

```bash
# Use the new docker-compose.local.yml file
docker-compose -f docker-compose.local.yml up -d
```

### 4. Check Status

```bash
docker-compose -f docker-compose.local.yml ps
```

## 🔄 Alternative: Development Mode (Hot Reload)

For development with live code changes:

```bash
cd docker
docker-compose -f docker-compose.yml down

# Mount the local code as a volume (add to docker-compose.yml):
# volumes:
#   - ../app:/var/app/app
#   - ../config:/var/app/config
#   - ../public:/var/app/public

docker-compose up
```

## 🌐 Accessing the Timeline Feature

1. Open your browser to `http://localhost:3000` (or your configured port)
2. Navigate to the Map page
3. Click the **"Timeline"** button in the top-left corner
4. The timeline slider will appear at the bottom of the map

## 🎮 Using the Timeline

- **Select Graph Type**: Choose between Speed, Battery, or Elevation
- **Drag Slider**: Move through time to see points appear progressively
- **Play/Pause**: Automatically animate through the timeline
- **Hide/Show**: Click the Timeline button again to toggle visibility

## 🔧 Troubleshooting

### Container Won't Start

```bash
# Check logs
cd docker
docker-compose -f docker-compose.local.yml logs -f dawarich_app
```

### Assets Not Loading

```bash
# Rebuild assets inside container
docker exec -it dawarich_app bundle exec rake assets:precompile
docker-compose -f docker-compose.local.yml restart dawarich_app
```

### Database Migration Issues

```bash
# Run migrations manually
docker exec -it dawarich_app bundle exec rails db:migrate
```

### Port Already in Use

Edit `docker/.env` and change:
```bash
DAWARICH_APP_PORT=3001  # Change from 3000
```

## 🔙 Reverting to Official Image

To go back to the official Dawarich image:

```bash
cd docker
docker-compose down
docker-compose -f docker-compose.yml up -d
```

## 📦 Image Management

### View Images
```bash
docker images | grep dawarich
```

### Remove Local Image
```bash
docker rmi dawarich-timeline:latest
```

### Rebuild Image
```bash
docker build -f docker/Dockerfile -t dawarich-timeline:latest . --no-cache
```

## 🔄 Updating the Timeline Feature

When new changes are committed to the timeline branch:

```bash
# Pull latest changes
git pull origin claude/add-timeline-slider-map-qGox6

# Rebuild and redeploy
./docker/deploy-timeline.sh
```

## ⚙️ Configuration Options

The timeline feature works with your existing `.env` configuration. No additional environment variables needed.

### Optional: Customize Timeline Settings

You can modify the timeline controller at:
- `app/javascript/controllers/maps/timeline_controller.js`

Rebuild the image after changes:
```bash
docker build -f docker/Dockerfile -t dawarich-timeline:latest .
docker-compose -f docker-compose.local.yml restart dawarich_app
```

## 🆘 Getting Help

- Check logs: `docker-compose -f docker-compose.local.yml logs -f`
- View container status: `docker ps -a | grep dawarich`
- Restart services: `docker-compose -f docker-compose.local.yml restart`

## 📊 System Requirements

Same as official Dawarich:
- **CPU**: 0.5 cores minimum (configurable)
- **Memory**: 4GB minimum (configurable)
- **Disk**: Sufficient for database and uploaded files

## 🔐 Security Notes

- The timeline feature is client-side only (JavaScript)
- No new API endpoints or authentication changes
- Uses existing Dawarich security model
- All user data remains private and secure

## 🎉 Feature Highlights

- **Interactive timeline slider** at bottom of map
- **Real-time graph visualization** (speed, battery, elevation)
- **Play/pause animation** controls
- **Smooth map synchronization**
- **Toggleable visibility**
- **DaisyUI styling** matching existing design

---

**Note**: This deployment guide is for the timeline feature branch. For production use, wait for the feature to be merged into the main Dawarich repository and use the official Docker image.
