# Use Ubuntu as base image for better compatibility
FROM ubuntu:22.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install required dependencies
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# Add Ollama repository and install Ollama
RUN curl -fsSL https://ollama.com/install.sh | sh

# Verify Ollama installation and version
RUN ollama --version && \
    which ollama && \
    # Verify the binary is from the official source
    sha256sum $(which ollama) | grep -q "$(curl -fsSL https://ollama.com/checksums.txt | grep $(uname -m) | awk '{print $1}')" || (echo "Ollama binary verification failed" && exit 1)

# Create a non-root user
RUN useradd -m -s /bin/bash ollama

# Create directory for Ollama data with proper permissions
RUN mkdir -p /home/ollama/.ollama && \
    chown -R ollama:ollama /home/ollama/.ollama && \
    chmod 700 /home/ollama/.ollama

# Define the volume after setting permissions
VOLUME ["/home/ollama/.ollama"]

# Switch to non-root user
USER ollama

# Set working directory
WORKDIR /home/ollama

# Expose Ollama API port
EXPOSE 11434

# Set environment variables
ENV OLLAMA_HOST=0.0.0.0
ENV OLLAMA_MODELS=/home/ollama/.ollama

# Run Ollama
CMD ["ollama", "serve"] 