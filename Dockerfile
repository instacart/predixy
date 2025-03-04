FROM debian:bullseye-slim

# Install required dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    g++ \
    make \
    git \
    && rm -rf /var/lib/apt/lists/*

# Set up working directory
WORKDIR /usr/src/predixy

# Clone Predixy from GitHub instead of using local source which might have incompatible object files
RUN git clone https://github.com/joyieldInc/predixy.git . && \
    cd /usr/src/predixy && \
    make clean && \
    make

# Create directory for configuration
RUN mkdir -p /etc/predixy

# Copy configuration files
COPY conf/predixy_docker.conf /etc/predixy/predixy.conf
COPY conf/latency.conf /etc/predixy/latency.conf

# Expose the port Predixy will listen on (as defined in the config)
EXPOSE 7617

# Command to run Predixy
CMD ["/usr/src/predixy/src/predixy", "/etc/predixy/predixy.conf"] 