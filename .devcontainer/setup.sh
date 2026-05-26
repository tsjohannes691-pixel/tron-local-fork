#!/bin/bash
set -e

echo "🔧 Setting up TRON Local Fork..."

# Update packages
sudo apt-get update
sudo apt-get install -y wget curl git

# Install Python dependencies
pip3 install tronpy

echo "✅ Dependencies installed"

# Create directories
mkdir -p output-directory/{database,index}

echo "✅ Directories created"
echo "📝 Run 'bash scripts/setup_fork.sh' to initialize the fork"