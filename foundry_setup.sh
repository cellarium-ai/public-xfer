#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status

# Update package list (requires sudo)
echo "Updating package list..."
sudo apt-get update -y || echo "Make sure your user has permission to run apt-get update"

# Install wget, bzip2, and curl if not already installed
echo "Checking and installing required packages..."
for pkg in wget bzip2 curl; do
    if ! command -v $pkg >/dev/null 2>&1; then
        echo "$pkg not found, installing..."
        sudo apt-get install -y $pkg
    fi
done

# Download and install Miniconda in user space
echo "Installing Miniconda..."
wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-py310_24.9.2-0-Linux-x86_64.sh -O /tmp/miniconda.sh
bash /tmp/miniconda.sh -b -p "$HOME/miniconda"
rm /tmp/miniconda.sh  # Clean up the installer
export PATH="$HOME/miniconda/bin:$PATH"  # Add Miniconda to PATH for the current session
conda init bash  # Initialize Conda for bash

# Source the updated bash configuration
if [ -f /home/ubuntu/.bashrc ]; then
    echo "Sourcing .bashrc..."
    source /home/ubuntu/.bashrc
else
    echo "Warning: .bashrc file not found."
fi

# Install Google Cloud CLI
echo "Installing Google Cloud CLI..."
sudo snap install google-cloud-cli --classic

# Initialize Google Cloud CLI
echo "Initializing Google Cloud CLI..."
gcloud init

# Navigate to the target directory and install Python development dependencies
TARGET_DIR="/mnt/cellariumgpt-xfer/mb-ml-dev-vm/cellarium-ml/"
if [ -d "$TARGET_DIR" ]; then
    echo "Navigating to $TARGET_DIR..."
    cd "$TARGET_DIR"
else
    echo "Error: Target directory $TARGET_DIR does not exist."
    exit 1
fi

# Install Python dependencies in development mode
echo "Installing Python development dependencies..."
pip install -e .[dev]
pip install scanpy[leiden] pymde colorcet ipywidgets
