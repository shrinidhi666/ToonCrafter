#!/bin/bash

# Step 1: Update the system
echo "Updating system..."
sudo yum update -y

# Step 2: Set up the instance store
echo "Setting up the instance store at /dev/nvme1n1..."
INSTANCE_STORE_DIR="/mnt/instance_store"

# Check if /dev/nvme1n1 exists
if [ -b "/dev/nvme1n1" ]; then
    echo "Instance store /dev/nvme1n1 detected. Formatting and mounting..."
    sudo mkfs.ext4 /dev/nvme1n1 -F
    sudo mkdir -p $INSTANCE_STORE_DIR
    sudo mount /dev/nvme1n1 $INSTANCE_STORE_DIR
    sudo chmod 777 $INSTANCE_STORE_DIR
else
    echo "Instance store /dev/nvme1n1 not found. Exiting..."
    exit 1
fi

echo "Instance store mounted at $INSTANCE_STORE_DIR."

# Step 3: Install Miniconda (if not already installed)
echo "Downloading Miniconda installer..."
curl -o $INSTANCE_STORE_DIR/Miniconda3-latest-Linux-x86_64.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
echo "Installing Miniconda..."
bash $INSTANCE_STORE_DIR/Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/miniconda
echo "Initializing Conda..."
$HOME/miniconda/bin/conda init
source ~/.bashrc
rm $INSTANCE_STORE_DIR/Miniconda3-latest-Linux-x86_64.sh
echo "Miniconda installation complete."
conda --version

# Step 4: Install Git
echo "Installing Git..."
sudo yum install -y git

# Step 5: Clone the ToonCrafter repository to instance store
echo "Cloning ToonCrafter repository..."
git clone https://github.com/shrinidhi666/ToonCrafter.git $INSTANCE_STORE_DIR/ToonCrafter
cd $INSTANCE_STORE_DIR/ToonCrafter

# Step 6: Download the model checkpoint
echo "Downloading model checkpoint..."
mkdir -p $INSTANCE_STORE_DIR/ToonCrafter/checkpoints/tooncrafter_512_interp_v1
curl -L -o $INSTANCE_STORE_DIR/ToonCrafter/checkpoints/tooncrafter_512_interp_v1/model.ckpt https://huggingface.co/Doubiiu/ToonCrafter/resolve/main/model.ckpt

# Step 7: Set up the Conda environment for ToonCrafter
echo "Setting up Conda environment..."
conda create -n tooncrafter python=3.8.5 -y
conda activate tooncrafter

# Step 8: Install required Python packages
echo "Installing Python packages..."
pip install -r $INSTANCE_STORE_DIR/ToonCrafter/requirements.txt

# Step 9: Run ToonCrafter script
echo "Running ToonCrafter script..."
sh $INSTANCE_STORE_DIR/ToonCrafter/scripts/run.sh

echo "Setup complete."
