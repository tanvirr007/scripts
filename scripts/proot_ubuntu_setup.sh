#!/bin/bash

echo "Updating and upgrading system packages..."
apt update && apt upgrade -y

echo "Installing required packages..."
apt install -y git python3 python3-pip python3-venv python3-dev build-essential wget nano

echo "Setting up virtual environment..."
if [ ! -d "venv" ]; then
    python3 -m venv venv
    echo "Virtual environment created."
else
    echo "Virtual environment already exists."
fi

source venv/bin/activate

echo "Upgrading pip..."
pip install --upgrade pip

echo "Installing required Python packages from requirements.txt..."
pip install -r requirements.txt

echo "Installing Pyrogram..."
pip install git+https://github.com/KurimuzonAkuma/pyrogram.git@v2.1.24

echo "Verifying installed packages..."
pip list

echo "Running your script..."
python3 -m hypernova
