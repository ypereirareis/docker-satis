# Docker Satis

[![Build Status](https://travis-ci.org/ypereirareis/docker-satis.svg?branch=master)](https://travis-ci.org/ypereirareis/docker-satis)
[![Docker Stars](https://img.shields.io/docker/stars/ypereirareis/docker-satis.svg)]()
[![ImageLayers Size](https://img.shields.io/imagelayers/image-size/ypereirareis/docker-satis/latest.svg)]()
[![Docker Pulls](https://img.shields.io/docker/pulls/ypereirareis/docker-satis.svg)]()
[![ImageLayers Layers](https://img.shields.io/imagelayers/layers/ypereirareis/docker-satis/latest.svg)]()

A docker image and configuration to run [Satis](https://github.com/composer/satis) very easily in seconds:

* Automatically (cron every minute)
* Manually ([http://127.0.0.1:3333/build](http://127.0.0.1:3333/build))
* Admin ([http://127.0.0.1](http://127.0.0.1))

## Requirements

* docker
* docker-compose
* make

## Install

```bash
cp .env.dist .env
cp parameters.satisfy.yml.dist parameters.satisfy.yml
cp satis.json.dist satis.json
make start
```

## The default config file for satis looks like this:

```json
{
    "name": "Private REPO",
    "homepage": "https:\/\/satis.domain.tld",
    "output-dir": "web",
    "output-html": true,
    "repositories": [
    ],
    "require-all": true,
    "require-dependencies": true,
    "require-dev-dependencies": true,
    "include-filename": "include\/all$%hash%.json",
    "minimum-stability": "dev",
    "providers": false
}

```

## Service management

* **Start**

```
make start
```

* **Stop**

```
make stop
```

* **Remove**

```
make remove
```

* **Status**

```
make state
```

## Satis/Satisfy access

* Home page
[http://satis.localhost](http://satis.localhost)

* Manual build / Web hook
[http://satis.localhost/admin/satis/build](http://satis.localhost/admin/satis/build)

* Admin
[http://satis.localhost/admin](http://satis.localhost/admin)

Default credentials are : **admin / foo** 

## Configuration override (if needed)

* Add your own custom `satis.json`
* Add your own custom `parameters.satisfy.yml` for Satisfy

```
satis:
    image: ypereirareis/docker-satis:5.0
    volumes:
        - "./parameters.satisfy.yml:/satisfy/app/config/parameters.yml"
        - "./satis.json:/satisfy/satis.json"
```

But I advise you to create your own image and Dockerfile:

```shell
FROM ypereirareis/docker-satis:5.0
...
ADD satis.json /satisfy/satis.json
ADD parameters.satisfy.yml /satisfy/app/config/parameters.yml
```

## **Build frequency**

* By default, building script is executed every minute thanks to the docker-compose configuration

```
satis:
    image: ypereirareis/docker-satis:5.0
    environment:
        CRONTAB_FREQUENCY: "*/1 * * * *"
```

* You can override this value changing the cron configuration: `*/5 * * * * OR */10 * * * *`
* Or you can disable cron with: `CRONTAB_FREQUENCY=-1`

## SSH key

* The container needs to know the ssh key you added in your private repo (and optionally your SSH configuration).

```
satis:
    image: ypereirareis/docker-satis:5.0
    volumes:
        - "~/.ssh/id_rsa:/var/tmp/id"
        - "~/.ssh/config:/var/tmp/sshconf"
```

You could add the key into your own image but be careful your ssh key will be in the image (DO NOT SHARE THE IMAGE TO THE WORLD):

```shell
FROM ypereirareis/docker-satis:5.0
...
ADD SSH_PATH/.ssh/id_rsa:/var/tmp/id
ADD SSH_PATH/.ssh/config:/var/tmp/sshconf
```

* The ssh fingerprints of private repos servers need to be added in the known_hosts file inside the container that's why we specify the URL through ENV variable.

**You can now add the ssh port of your server `yourownserver.com:54322` and it supports rsa and dsa keys**

```
satis:
    image: ypereirareis/docker-satis:5.0
    environment:
        PRIVATE_REPO_DOMAIN_LIST: bitbucket.org gitlab.com github.com yourownserver.com:54322
```

## Composer cache

Cache should be shared with the host to be reused when you restart the container, for better performance.

```
satis:
    image: ypereirareis/docker-satis:5.0
    volumes:
        - "/var/tmp/composer:/root/.composer"
```


## Outside world

If you want to give access satis to the outside world, you should use a reverse proxy.

Below is a working setup for NGINX:

```
server {
    server_name satis.domain.tld;

    location / {
        proxy_pass http://127.0.0.1:80;
    }
}
```

## Tests

```shell
./tests.sh
```

## LICENSE

The MIT License (MIT)

Copyright (c) 2017 Yannick Pereira-Reis

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
