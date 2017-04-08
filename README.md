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

## The default config file for satis looks like this:

```json
{
    "name": "My Private Repo",
    "homepage": "https://satis.domain.tld",
    "repositories": [
    ],
    "require-all":true,
    "require-dependencies":true,
    "require-dev-dependencies":true,
    "minimum-stability":"dev"
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
[http://127.0.0.1](http://127.0.0.1)

* Manual build / Web hook
[http://127.0.0.1:3333/build](http://127.0.0.1:3333/build)

* Admin
[http://127.0.0.1/admin](http://127.0.0.1/admin)

Default credentials are : **admin / foo** as you can see in [this config file](./config.php#L43-55).
You will also find instructions to change or add credentials in this section of the file.

## Configuration override (if needed)

* Add your own custom `config.json` (aka satis.json)
* Add your own custom `config.php` for Satisfy

```
satis:
    image: ypereirareis/docker-satis:4.3
    volumes:
        - ./config.php:/app/config.php
        - ./config.json:/app/config.json
```

But I advise you to create your own image and Dockerfile:

```shell
FROM ypereirareis/docker-satis:4.3
...
ADD config.php /app/config.php
ADD config.json /app/config.json
```

## **Build frequency**

* By default, building script is executed every minute thanks to the docker-compose configuration

```
satis:
    image: ypereirareis/docker-satis:4.3
    environment:
        CRONTAB_FREQUENCY: "*/1 * * * *"
```

* You can override this value changing the cron configuration: `*/5 * * * * OR */10 * * * *`
* Or you can disable cron with: `CRONTAB_FREQUENCY=-1`

## SSH key

* The container needs to know the ssh key you added in your private repo (and optionally your SSH configuration).

```
satis:
    image: ypereirareis/docker-satis:4.3
    volumes:
        - "~/.ssh/id_rsa:/var/tmp/id"
        - "~/.ssh/config:/var/tmp/sshconf"
```

You could add the key into your own image but be careful your ssh key will be in the image (DO NOT SHARE THE IMAGE TO THE WORLD):

```shell
FROM ypereirareis/docker-satis:4.3
...
ADD SSH_PATH/.ssh/id_rsa:/var/tmp/id
ADD SSH_PATH/.ssh/config:/var/tmp/sshconf
```

* The ssh fingerprints of private repos servers need to be added in the known_hosts file inside the container that's why we specify the URL through ENV variable.

**You can now add the ssh port of your server `yourownserver.com:54322` and it supports rsa and dsa keys**

```
satis:
    image: ypereirareis/docker-satis:4.3
    environment:
        PRIVATE_REPO_DOMAIN_LIST: bitbucket.org gitlab.com github.com yourownserver.com:54322
```

## Composer cache

Cache should be shared with the host to be reused when you restart the container, for better performance.

```
satis:
    image: ypereirareis/docker-satis:4.3
    volumes:
        - "/var/tmp/composer:/root/.composer"
```


## Ports

If you want to build on port 8888 and access the interface on port 5000 :

```
satis:
    image: ypereirareis/docker-satis:4.3
    ports:
        - 8888:3000
        - 5000:80

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
