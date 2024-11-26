#!/bin/bash

# Update package list (user-level commands; no sudo)
sudo apt-get update -y || echo "Make sure your user has permission to run apt-get update"

# Install wget, bzip2, and curl if not already installed
command -v wget >/dev/null 2>&1 || { echo >&2 "wget not found, installing..."; sudo apt-get install -y wget; }
command -v bzip2 >/dev/null 2>&1 || { echo >&2 "bzip2 not found, installing..."; sudo apt-get install -y bzip2; }
command -v curl >/dev/null 2>&1 || { echo >&2 "curl not found, installing..."; sudo apt-get install -y curl; }

# Download and install Miniconda in user space
wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-py310_24.9.2-0-Linux-x86_64.sh -O /tmp/miniconda.sh
bash /tmp/miniconda.sh -b -p "$HOME/miniconda"

# Clean up the installer
rm /tmp/miniconda.sh

# Add Miniconda to PATH for the current session
export PATH="$HOME/miniconda/bin:$PATH"

# Initialize Conda for bash
conda init bash
