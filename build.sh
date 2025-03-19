#!/bin/bash

# Install system dependencies required for dlib
apt-get update
apt-get install -y cmake g++ wget unzip

# Install Python dependencies
pip install --no-cache-dir -r requirements.txt
