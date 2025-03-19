# Use official Python image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy project files
COPY . .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Explicitly set Railway PORT
ENV PORT=5000  

# Expose the port
EXPOSE 5000  

# Start the Flask app with Gunicorn
CMD ["gunicorn", "-w", "1", "-b", "0.0.0.0:5000", "mai:app"]
