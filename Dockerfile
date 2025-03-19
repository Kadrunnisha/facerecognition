# Use an official lightweight Python image with OpenCV support
FROM python:3.9

# Install system dependencies
RUN apt-get update && apt-get install -y cmake g++ wget unzip

# Set the working directory
WORKDIR /app

# Copy the application files
COPY . /app

# Install required Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose the port used by Flask
EXPOSE 5000

# Start the application
CMD ["gunicorn", "-w", "1", "-b", "0.0.0.0:5000", "mai:app"]
