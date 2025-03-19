# Use official Python image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install dependencies
RUN apt-get update && apt-get install -y cmake g++ wget unzip 

# Copy project files
COPY . .

# Install Python dependencies
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Set default PORT explicitly
ENV PORT=5000  

# Expose the application port
EXPOSE 5000  

# Start Gunicorn server
CMD ["gunicorn", "-w", "1", "-b", "0.0.0.0:5000", "mai:app"]
