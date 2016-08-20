# docker-marathon-kong

This an extension of the [official Docker image][docker-kong-url] for [Kong][kong-url], with support for easy clustering when running on a [mesos][mesos-url]/[marathon][marathon-url] platform.

This repo is based heavily on [LittleBayDigital's docker image][littlebaydigital-docker-url].

# Justifications

The official docker-kong image allows for:

1. linking `Postgres` or `Cassandra`  database containers
2. connecting to external databases via custom `kong.yml` config file by replacing the `/etc/kong/` volume.

However when using `Mesos` and `Marathon` containers are deployed across multiple nodes in a cluster. Therefore it's not feasible to mount custom config files into volumes on each machine which are spun up and down on demand. See related question [here][envvar-question]].

When running multiple instances of Kong on multiple nodes there is a need to advertise to the rest of the cluster the ip and port a specific instance can be reached on.

Marathon injects the hostname and the mapped ports as environment variables into the container. By using these Kong can be configured to tell the other nodes in the cluster which external ip:port it can be reached.

# Supported tags and respective `Dockerfile` links

- `0.8.3`  - *([Dockerfile](https://github.com/bakstad/docker-marathon-kong/blob/0.8.3/Dockerfile))*
- `latest` - *([Dockerfile](https://github.com/bakstad/docker-marathon-kong/blob/0.8.3/Dockerfile))*

# How to use this image

Existing `docker-kong` usages still applies.

## Marathon

Marathon injects `$HOST` and `$PORT{n}` into the environment of the container.

It is assumed that the following port configuration is used in the marathon app file:

| Container Port | Env Var | TCP/UDP |
| -------------- | ------- | ------- |
| 8000 | `$PORT0` | tcp |
| 8001 | `$PORT1` | tcp |
| 8443 | `$PORT2` | tcp |
| 7946 | `$PORT3` | udp,tcp |

## Environment variables

The following extra Environment Variables are added:

### Kong Environment Variables:

| Env Var | Default | Description |
| --------|---------| ------------|
| DATABASE | postgres | either postgres or cassandra as per official image |

### Postgres Environment Variables:

| Env Var | Default | Description |
| --------|---------| ------------|
| POSTGRES_HOST | kong-database | Mandatory. Specify custom values as an IP, hostname or use a internal service name |
| POSTGRES_PORT | 5432 | Optional |
| POSTGRES_DB | kong | Optional |
| POSTGRES_USER | kong | Optional |
| POSTGRES_PASSWORD | no password | Optional |

### Cluster Environment Variables:

| Env Var | Default | Description |
| --------|---------| ------------|
| TTL_ON_FAILURE | 3600 | Optional. |

[kong-url]: http://getkong.org
[docker-kong-url]: https://hub.docker.com/r/mashape/kong/
[envvar-question]: https://groups.google.com/forum/#!topic/konglayer/mfjBUwQHHHk
[mesos-url]: http://mesos.apache.org/
[marathon-url]: https://mesosphere.github.io/marathon/
[littlebaydigital-docker-url]:https://github.com/LittleBayDigital/docker-kong-service
