# Start with PyTorch base image with CUDA support
FROM pytorch/pytorch:2.0.1-cuda11.7-cudnn8-runtime

# Set working directory
WORKDIR /app

# Install system dependencies required for OpenCV and other packages
RUN apt-get update && apt-get install -y \
    libgl1-mesa-glx \
    libglib2.0-0 \
    git \
    wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create directory for models
RUN mkdir -p /app/models

# Copy requirements file
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Make sure scripts are executable
RUN chmod +x *.py

# Create a volume for persistent storage of downloaded models
VOLUME /app/models

# Expose the port Gradio will run on
EXPOSE 7860

# Environment variable to select demo type (foreground or background)
ENV DEMO_TYPE=foreground

# Command to run the application
CMD ["sh", "-c", "if [ \"$DEMO_TYPE\" = \"background\" ]; then python gradio_demo_bg.py; else python gradio_demo.py; fi"]
