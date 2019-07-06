# frickl-docker

## Using Docker Compose
Modify `docker-compose.yml` and bind your image folder into the container:

```
version: '3.3'
services:
    frickl:
        image: frickl
        [...]
        volumes:
          - type: bind
            source: /path/to/your/images
            target: /data/images
```

```
docker-compose up -d
```

## Using plain Docker
```
docker network create frickl

docker run -d \
    --name mysql \
    --net frickl \
    --env MYSQL_ROOT_PASSWORD=FricklIsAwesome \
    --env MYSQL_DATABASE=frickl \
    --env MYSQL_USER=frickl \
    --env MYSQL_PASSWORD=frickl \
    --mount source=frickl-mysql,target=/var/lib/mysql \
    --restart unless-stopped
    yobasystems/alpine-mariadb:arm32v7

docker run -d \
    --name frickl \
    --net frickl \
    --env JAVA_OPTS=-Xmx512m \
    --mount type=bind,source=/path/to/your/images,target=/data/images
    -p 80:8080 \
    --restart unless-stopped
    sebastianraubach/frickl:arm
```
