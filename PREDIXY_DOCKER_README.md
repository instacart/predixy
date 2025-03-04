# Predixy Docker Setup

This repository contains Docker configuration for running [Predixy](https://github.com/joyieldInc/predixy), a high-performance Redis proxy, in a Docker environment with the ability to connect to an external Redis server.

## Prerequisites

- Docker
- Docker Compose
- An accessible Redis server (either on the host machine or on another server)

## Configuration

The Docker setup uses the `predixy_docker.conf` configuration file which is designed to connect to an external Redis server. By default, it's configured to connect to a Redis server running on your host machine at port 6379.

### Connecting to a Different Redis Server

If your Redis server is not running on your host machine or is using a different port, you need to modify the `predixy_docker.conf` file:

1. Open `conf/predixy_docker.conf`
2. Find the `StandaloneServerPool` section
3. Update the Redis server address in the `Group local` section:

```
Group local {
    + your.redis.server:port
}
```

## Building and Running with Docker Compose

To build and start the Predixy container:

```bash
docker-compose up -d
```

This will:
1. Build the Predixy Docker image
2. Start the container
3. Expose the Predixy proxy service on port 7617

## Testing the Connection

Once the container is running, you can test the connection to Predixy:

```bash
redis-cli -p 7617 info
```

This should connect to the Predixy proxy and show information about the Redis server it's connected to.

## Using Custom Redis Authentication

If your Redis server requires authentication, you should update the configuration file to include the appropriate auth settings in the `Authority` section.

## Troubleshooting

### Cannot Connect to Redis Server

If Predixy cannot connect to your Redis server, check the following:

1. Ensure Redis is running and accessible from the Docker container
2. Check the Redis server address in `predixy_docker.conf`
3. If Redis is running on the host machine:
   - Make sure the `extra_hosts` entry in `docker-compose.yml` is correct
   - Verify that Redis is configured to accept connections from external IPs (bind 0.0.0.0)
4. Check Redis authentication requirements if applicable

### Viewing Logs

To view the logs from the Predixy container:

```bash
docker-compose logs predixy
```

## Advanced Configuration

For more advanced configuration options, please refer to the [Predixy documentation](https://github.com/joyieldInc/predixy). 