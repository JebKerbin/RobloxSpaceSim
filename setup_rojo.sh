#!/bin/bash

echo "Starting Rojo setup..."

# Make sure we're in the right directory
cd "$(dirname "$0")"
echo "Current directory: $(pwd)"

# Check for required commands
command -v curl >/dev/null 2>&1 || { echo "curl is required but not installed. Aborting."; exit 1; }
command -v unzip >/dev/null 2>&1 || { echo "unzip is required but not installed. Aborting."; exit 1; }

# Download latest Rojo release
echo "Downloading Rojo..."
curl -L https://github.com/rojo-rbx/rojo/releases/latest/download/rojo-linux-x64.zip -o rojo.zip
if [ ! -f rojo.zip ]; then
    echo "Failed to download rojo.zip"
    exit 1
fi
echo "Downloaded rojo.zip successfully"
ls -la rojo.zip

# Unzip Rojo
echo "Extracting Rojo..."
unzip -o rojo.zip
echo "Directory contents after extraction:"
ls -la

# Make Rojo executable
echo "Making Rojo executable..."
if [ ! -f rojo ]; then
    echo "rojo binary not found after extraction"
    exit 1
fi
chmod +x rojo
echo "Made rojo executable"

# Initialize Rojo project if default.project.json doesn't exist
if [ ! -f "default.project.json" ]; then
    echo "Initializing Rojo project..."
    ./rojo init
fi

# Start Rojo server
echo "Starting Rojo server..."
./rojo serve