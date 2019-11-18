<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Docker Envoy Redis Cluster](#docker-envoy-redis-cluster)
  - [Goal](#goal)
  - [Configuration](#configuration)
  - [Usage](#usage)
  - [Simulating Networking Errors](#simulating-networking-errors)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

Docker Envoy Redis Cluster
=======
Docker compose Redis Clusters with Envoy proxy.

Goal
-----
This repo aim to make it quick and simple to get a redis cluster up and running with Envoy as the proxy.
The primary use for this cluster is for demo/experimentation/presentation/development running on your location machine.

It this not intended for production use.

Configuration
-----
This contains 2 Redis clusters, one with cluster mode enabled another with cluster mode disabled and rely on Envoy the partition the keyspace.

####Cluster mode enabled
The cluster mode enabled cluster is exposed through Envoy on port 6380.  Here's the list of nodes in the cluster mode enabled cluster.  

| IP | Port | Role |
| --------- |:----:| -------:|
| 172.25.0.2| 7002 | master |
| 172.25.0.3| 7003 | master |
| 172.25.0.4| 7004 | master |
| 172.25.0.5| 7005 | replica |
| 172.25.0.6| 7006 | replica |
| 172.25.0.7| 7007 | replica |

####Cluster mode disabled
In cluster mode disabled cluster is exposed through Envoy on port 6381.  By default there's only a single node, but it can be scaled using
```bash
docker-compose up -d --scale redis-server=3
``` 
or
```bash
docker-compose scale redis-server=3
```

Usage
-----
#####Build and start all containers
```bash
docker-compose up --build -d
```

#####View Containers
```bash
docker-compose ps
```

#####Logs
To view the envoy logs.
```bash
docker-compose logs envoy
```

#####Envoy Admin Endpoint
Open [http://localhost:9901/](http://localhost:9901/) in your browser. 

####Connect to Redis Cluster
#####Cluster mode enabled
To connect to envoy to the redis cluster 0(cluster mode enabled)
```bash
docker-compose exec envoy redis-cli -p 6380
```
To bypass envoy and connect to one of the nodes directly.
```bash
docker-compose exec envoy redis-cli -c -h 172.25.0.2 -p 7002
```

#####Cluster mode disabled
To connect to envoy to the redis cluster 1(cluster mode disabled)
```bash
docker-compose exec envoy redis-cli -p 6381
```

#####Cleanup
```bash
docker-compose down
```

Simulating Networking Errors
-----
We use [Pumba](https://github.com/alexei-led/pumba) for simulating networking errors.

#####Network partition
The following example will cause a 1 minute network partition between redis-replica-1 and the rest of the cluster
```bash
docker-compose run -rm pumba netem --duration 1m --target 172.25.0.2 --target 172.25.0.3 --target 172.25.0.4 --target 172.25.0.5 --target 172.25.0.7 loss -p 100 docker-envoy-redis-cluster_redis-replica-1_1
```