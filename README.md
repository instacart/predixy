# Predixy [中文版](https://github.com/joyieldInc/predixy/blob/master/README_CN.md)

**Predixy** is a high performance and fully featured proxy for redis sentinel and redis cluster

## Features

+ High performance and lightweight.
+ Multi-threads support.
+ Works on Linux, OSX, BSD, Windows([Cygwin](http://www.cygwin.com/)).
+ Supports Redis Sentinel, single/multi redis group[s].
+ Supports Redis Cluster.
+ Supports redis block command, eg:blpop, brpop, brpoplpush.
+ Supports scan command, even multi redis instances.
+ Multi-keys command support: mset/msetnx/mget/del/unlink/touch/exists.
+ Multi-databases support, means redis command select is avaliable.
+ Supports redis transaction, limit in Redis Sentinel single redis group.
+ Supports redis Scripts, script load, eval, evalsha.
+ Supports redis Pub/Sub.
+ Multi-DataCenters support, read from slaves.
+ Extend AUTH, readonly/readwrite/admin permission, keyspace limit.
+ Log level sample, async log record.
+ Log file auto rotate by time and/or file size.
+ Stats info, CPU/Memory/Requests/Responses and so on.
+ Latency monitor.

## Generic Build Instructions

Predixy can be compiled and used on Linux, OSX, BSD, Windows([Cygwin](http://www.cygwin.com/)). Requires C++11 compiler.

It is as simple as:

    $ make

To build in debug mode:

    $ make debug

Some other build options:
+ CXX=c++compiler, default is g++, you can specify other, eg:CXX=clang++
+ EV=epoll|poll|kqueue, default it is auto detect according by platform.
+ MT=false, disable multi-threads support.
+ TS=true, enable predixy function call time stats, debug only for developer.

For examples:

    $ make CXX=clang++
    $ make EV=poll
    $ make MT=false
    $ make debug MT=false TS=true

## Generic Install Instructions

Just copy src/predixy to the install path

    $ cp src/predixy /path/to/bin

## Generic Configuration Instructions

See below files:
+ predixy.conf, basic config, will refrence below config files.
+ cluster.conf, Redis Cluster backend config.
+ sentinel.conf, Redis Sentinel backend config.
+ auth.conf, authority control config.
+ dc.conf, multi-datacenters config.
+ latency.conf, latency monitor config.

## Running

    $ src/predixy conf/predixy.conf

With default predixy.conf, Predixy will listen at 0.0.0.0:7617 and
proxy to Redis Cluster 127.0.0.1:6379.
In general, 127.0.0.1:6379 is not running in Redis Cluster mode.
So you will look mass log output, but you can still test it with redis-cli.

    $ redis-cli -p 7617 info

More command line arguments:

    $ src/predixy -h

## Stats

Like redis, predixy use INFO command to give stats.

Show predixy running info and latency monitors

    redis> INFO

Show latency monitors by latency name

    redis> INFO Latency <latency-name>

A latency monitor example:

    LatencyMonitorName:all
                latency(us)   sum(us)           counts
    <=          100              3769836            91339 91.34%
    <=          200               777185             5900 97.24%
    <=          300               287565             1181 98.42%
    <=          400               185891              537 98.96%
    <=          500               132773              299 99.26%
    <=          600                85050              156 99.41%
    <=          700                85455              133 99.54%
    <=          800                40088               54 99.60%
    <=         1000                67788               77 99.68%
    >          1000               601012              325 100.00%
    T            60              6032643           100001
    The last line is total summary, 60 is average latency(us)


Show latency monitors by server address and latency name

    redis> INFO ServerLatency <server-address> [latency-name]

Reset all stats and latency monitors, require admin permission.

    redis> CONFIG ResetStat

## Instacart Local Development Instructions

### Prerequisites
- Local Redis instance running on default port (6379)
- C++11 compiler
- Make

### Install Redis Locally 

1. Use Homebrew to install Redis in a single instance mode with cluster mode disabled to test your changes locally
```bash
$ brew install redis
```

2. Start Redis
```bash
$ brew services start redis
```

3. Verify your local Redis is running:
```bash
$ redis-cli -h 127.0.0.1 -p 6379 ping
```
Should return "PONG"

```bash
$ redis-cli -h 127.0.0.1 -p 6379 info
```

Will return info about the Redis instance, if required for debugging

Note, logs for Redis installed by Brew will appear in `/opt/homebrew/var/log/redis.log` by default. 

### Building and Running Predixy Locally

1. Compile Predixy:
```bash
$ make
```
This will create object files and the executable in the `src` directory.

2. Verify your local Redis is running:
```bash
$ redis-cli -h 127.0.0.1 -p 6379 ping
```
Should return "PONG"

3. Start Predixy using the local configuration:
```bash
$ src/predixy conf/predixy_local.conf
```
You should see output indicating Predixy is listening on 127.0.0.1:7617

4. Test the connection through Predixy:
```bash
# Basic connectivity test
$ redis-cli -h 127.0.0.1 -p 7617 ping

# Check Predixy status
$ redis-cli -h 127.0.0.1 -p 7617 info

# Test read/write operations
$ redis-cli -h 127.0.0.1 -p 7617 set test "Hello via Predixy"
$ redis-cli -h 127.0.0.1 -p 7617 get test
```

5. To stop Predixy:
```bash
$ pkill -f predixy
```

### Notes
- Predixy will be listening on port 7617 while your Redis instance remains on 6379
- The configuration in `predixy_local.conf` is set up for a single local Redis instance
- Build artifacts (*.o files) are ignored by git but can be safely kept for development
- Logs will appear in stdout by default

## Benchmark

predixy is fast, how fast? more than twemproxy, codis, redis-cerberus

See wiki
[benchmark](https://github.com/joyieldInc/predixy/wiki/Benchmark)

## License

Copyright (C) 2017 Joyield, Inc. <joyield.com#gmail.com>

All rights reserved.

License under BSD 3-clause "New" or "Revised" License

WeChat:cppfan ![wechat](https://github.com/joyieldInc/predixy/blob/master/doc/wechat-cppfan.jpeg)

## Local Redis Cluster Setup and Testing

### Setting up Redis Cluster Locally

1. Create directories for each Redis node (we'll use 3 nodes):
```bash
$ mkdir -p redis-cluster/{7000,7001,7002}
```

2. Create Redis configuration for each node. First for port 7000:
```bash
$ cat > redis-cluster/7000/redis.conf << EOL
port 7000
cluster-enabled yes
cluster-config-file nodes-7000.conf
cluster-node-timeout 5000
appendonly yes
dir ./
bind 127.0.0.1
daemonize no
EOL
```

3. Copy and adjust configuration for other nodes:
```bash
$ cp redis-cluster/7000/redis.conf redis-cluster/7001/redis.conf
$ cp redis-cluster/7000/redis.conf redis-cluster/7002/redis.conf
$ sed -i '' 's/7000/7001/g' redis-cluster/7001/redis.conf
$ sed -i '' 's/7000/7002/g' redis-cluster/7002/redis.conf
```

4. Start each Redis instance (in separate terminal windows):
```bash
$ redis-server redis-cluster/7000/redis.conf
$ redis-server redis-cluster/7001/redis.conf
$ redis-server redis-cluster/7002/redis.conf
```

5. Create the cluster:
```bash
$ redis-cli --cluster create 127.0.0.1:7000 127.0.0.1:7001 127.0.0.1:7002 --cluster-replicas 0
```
Type 'yes' when prompted to accept the configuration.

6. Verify cluster status:
```bash
$ redis-cli -p 7000 cluster nodes
```

### Testing with Predixy

1. Start Predixy with the cluster configuration:
```bash
$ src/predixy conf/predixy_cluster.conf
```

2. Test the cluster setup through Predixy:
```bash
# Basic connectivity test
$ redis-cli -p 7617 set test "Hello Cluster"
$ redis-cli -p 7617 get test

# Check Predixy cluster status
$ redis-cli -p 7617 info
```

### Cleanup
When done testing, you can:
1. Stop Predixy (Ctrl+C or `pkill predixy`)
2. Stop each Redis instance (Ctrl+C in each terminal)
3. Remove cluster files: `rm -rf redis-cluster`

Note: The cluster setup distributes keys across all nodes using hash slots. Each node in this setup handles approximately 5461 hash slots (16384/3 slots per node).
