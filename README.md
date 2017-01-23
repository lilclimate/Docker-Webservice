# Docker-WebServer
Setting up a local web server on OSX by docker.

## STEP 1
Git clone.
```
cd ~
git clone https://github.com/lilclimate/Docker-WebServer.git
```

## STEP 2
Get the CentOS image from Docker Hub.
```
docker pull centos:6.6
```

## STEP 3
Build one base image for development.
```
cd ~/Docker-WebServer/centos6
sh ./build.sh
```

## STEP 4
Build nginx image.
```
cd ~/Docker-WebServer/nginx1.11
sh ./build.sh
```

## STEP 5
Set up the site path.
```
mv ~/Docker-WebServer/data ~/data
```
Change the site path if you need.
```
vi ~/Docker-WebServer/docker-compose.yml
www-data:
        container_name: www-data
        image:          centos:6.6
        command:        /bin/bash
        volumes:
                        - ~/data/etc:/data/etc
                        - ~/data/sh:/data/sh
                        - ~/data/www:/data/www

```

## STEP 6
Set up the web server.
```
cd ~/Docker-WebServer
docker-compose up -d
```
