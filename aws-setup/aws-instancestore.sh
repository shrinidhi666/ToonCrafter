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
