#!/bin/bash

# Ensure script is executable
chmod +x setup_rojo.sh

# Download latest Rojo release
curl -L https://github.com/rojo-rbx/rojo/releases/latest/download/rojo-linux-x64.zip -o rojo.zip

# Unzip Rojo
unzip rojo.zip

# Make Rojo executable
chmod +x rojo

# Create basic Rojo project if not exists
./rojo init

# Start Rojo server
./rojo serve
