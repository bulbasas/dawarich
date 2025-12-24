#!/bin/bash

# Dawarich Timeline Feature Deployment Script
# This script builds and deploys the timeline feature to Docker containers

set -e  # Exit on error

echo "🚀 Dawarich Timeline Deployment"
echo "================================"
echo ""

# Check if we're in the right directory
if [ ! -f "docker/Dockerfile" ]; then
    echo "❌ Error: Please run this script from the dawarich root directory"
    exit 1
fi

# Check if we're on the right branch
CURRENT_BRANCH=$(git branch --show-current)
echo "📍 Current branch: $CURRENT_BRANCH"

if [ "$CURRENT_BRANCH" != "claude/add-timeline-slider-map-qGox6" ]; then
    echo "⚠️  Warning: You're not on the timeline feature branch"
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

echo ""
echo "🔨 Step 1: Building Docker image..."
docker build -f docker/Dockerfile -t dawarich-timeline:latest .

if [ $? -eq 0 ]; then
    echo "✅ Image built successfully"
else
    echo "❌ Failed to build image"
    exit 1
fi

echo ""
echo "🛑 Step 2: Stopping existing containers..."
cd docker
docker-compose -f docker-compose.local.yml down

echo ""
echo "🚀 Step 3: Starting containers with new image..."
docker-compose -f docker-compose.local.yml up -d

echo ""
echo "⏳ Waiting for services to be healthy..."
sleep 5

echo ""
echo "📊 Container status:"
docker-compose -f docker-compose.local.yml ps

echo ""
echo "✅ Deployment complete!"
echo ""
echo "🌐 Access Dawarich at: http://localhost:3000"
echo "📋 Timeline button is in the top-left corner of the map"
echo ""
echo "📝 Useful commands:"
echo "  - View logs:    cd docker && docker-compose -f docker-compose.local.yml logs -f dawarich_app"
echo "  - Stop:         cd docker && docker-compose -f docker-compose.local.yml down"
echo "  - Restart:      cd docker && docker-compose -f docker-compose.local.yml restart dawarich_app"
echo ""
