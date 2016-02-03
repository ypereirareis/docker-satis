# Docker Satis

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
    image: ypereirareis/docker-satis:3.0
    volumes:
        - ./config.php:/app/config.php
        - ./config.json:/app/config.json
```

## **Build frequency**

* By default, building script is executed every minute thanks to the docker-compose configuration

```
satis:
    image: ypereirareis/docker-satis:3.0
    environment:
        CRONTAB_FREQUENCY: "*/1 * * * *"
```

* You can override this value changing the cron configuration: `*/5 * * * * OR */10 * * * *`
* Or you can disable cron with: `CRONTAB_FREQUENCY=-1`

## SSH key

* The container needs to know the ssh key you added in your private repo.

```
satis:
    image: ypereirareis/docker-satis:3.0
    volumes:
        - "~/.ssh/id_rsa:/var/tmp/id"
```

* The ssh fingerprints of private repos servers need to be added in the known_hosts file inside the container that's why we specify the URL through ENV variable.

```
satis:
    image: ypereirareis/docker-satis:3.0
    environment:
        PRIVATE_REPO_DOMAIN_LIST: bitbucket.org gitlab.com github.com
```

## Composer cache

Cache should be shared with the host to be reused when you restart the container, for better performance.

```
satis:
    image: ypereirareis/docker-satis:3.0
    volumes:
        - "/var/tmp/composer:/root/.composer"
```


## Ports

If you want to build on port 8888 and access the interface on port 5000 :

```
satis:
    image: ypereirareis/docker-satis:3.0
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

