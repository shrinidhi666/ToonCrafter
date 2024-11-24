#!/bin/bash

# Step 1: Update the system
echo "Updating system..."
sudo yum update -y

# Step 2: Install Miniconda (if not already installed)
echo "Downloading Miniconda installer..."
curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
echo "Installing Miniconda..."
bash Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/miniconda
echo "Initializing Conda..."
$HOME/miniconda/bin/conda init
source ~/.bashrc
rm Miniconda3-latest-Linux-x86_64.sh
echo "Miniconda installation complete."
conda --version

# Step 3: Install Git
echo "Installing Git..."
sudo yum install -y git

# Step 4: Clone the ToonCrafter repository
echo "Cloning ToonCrafter repository..."
git clone https://github.com/shrinidhi666/ToonCrafter.git
cd ToonCrafter

# Step 5: Download the model checkpoint
echo "Downloading model checkpoint..."
mkdir -p checkpoints/tooncrafter_512_interp_v1
curl -L -o checkpoints/tooncrafter_512_interp_v1/model.ckpt https://huggingface.co/Doubiiu/ToonCrafter/resolve/main/model.ckpt

# Step 6: Set up the Conda environment for ToonCrafter
echo "Setting up Conda environment..."
conda create -n tooncrafter python=3.8.5 -y
conda activate tooncrafter

# Step 7: Install required Python packages
echo "Installing Python packages..."
pip install -r requirements.txt

# Step 8: Run ToonCrafter script
echo "Running ToonCrafter script..."
sh scripts/run.sh

echo "Setup complete."
