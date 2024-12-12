#!/bin/bash

# Exit on any error
set -e

# Define repository URL and folder
REPO_URL="https://github.com/shrinidhi666/ToonCrafter.git"
REPO_FOLDER="ToonCrafter"

# Install dependencies
sudo yum update -y
sudo yum install -y git wget

# Clone repository
if [ ! -d "$REPO_FOLDER" ]; then
    git clone $REPO_URL
else
    echo "Repository already exists. Skipping clone."
fi

cd $REPO_FOLDER

# Ensure Conda is installed
if ! command -v conda &> /dev/null; then
    echo "Conda not found. Please install Miniconda first."
    exit 1
fi

# Check if the environment exists
ENV_NAME="tooncrafter"
if conda info --envs | grep -q "^$ENV_NAME "; then
    echo "Conda environment '$ENV_NAME' already exists. Activating it..."
else
    echo "Creating Conda environment '$ENV_NAME' with Python 3.8.5..."
    conda create -n $ENV_NAME python=3.8.5 -y
fi

# Activate the environment
source $(conda info --base)/etc/profile.d/conda.sh
conda activate $ENV_NAME

# Install dependencies from requirements
pip install -r requirements.txt

# Final message
echo "ToonCrafter setup complete!"
