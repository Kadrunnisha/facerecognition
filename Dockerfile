# Use a base image with Python and system dependencies pre-installed
FROM ubuntu:20.04

# Set non-interactive mode for apt-get
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies for dlib, OpenCV, and face recognition
RUN apt-get update && apt-get install -y \
    git \
    cmake \
    g++ \
    python3-dev \
    python3-pip \
    libopenblas-dev \
    liblapack-dev \
    libx11-dev \
    libgtk2.0-dev \
    libboost-python-dev \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy the project files
COPY . /app

# Install Python dependencies
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Expose the application port
EXPOSE 5000

# Run the application
CMD ["gunicorn", "-w", "1", "-b", "0.0.0.0:5000", "mai:app"]
