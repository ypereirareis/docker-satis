# Docker Satis

A docker image and configuration to run Satis very easily in seconds:

* Automatically (cron every minute)
* Manually (http://127.0.0.1:3033/build)

**DO NOT forget to create a `config.json` file compatible with satis in your directory before starting the docker container.**

## Run the container

In this command do not forget to replace:

* toto.tata.tutu.com with your private repository URL in `-e PRIVATE_REPO_DOMAIN=toto.tata.tutu.com`

```
docker run -it -p 3033:3000 \
  -v $(pwd):/app \
  -v "${HOME}/.ssh/id_rsa":/var/tmp/id \
  -v /var/tmp/composer:/root/.composer \
  -e PRIVATE_REPO_DOMAIN=toto.tata.tutu.com \
  -d ypereirareis/docker-satis
```

**Crontab**

By default, building script is executed every minute thanks to the crontab configuration

`* * * * * root /satis/build.sh >> /var/log/satis-cron.log 2>&1`

You can override this value with an ENV variable:

`-e CRONTAB_FREQUENCY="*/10 * * * *"`

Or you can disable cron with this ENV variable value:

`-e CRONTAB_FREQUENCY="-1"` or `-e CRONTAB_FREQUENCY=-1`

**SSH key**

The container needs to know the ssh key you aded in your private repo.

`-v "${HOME}/.ssh/id_rsa":/var/tmp/id`

The ssh fingerprint of the private repo server needs to be added in the known_hosts file inside the container that's why we specify the URL through ENV variable.

`-e PRIVATE_REPO_DOMAIN=toto.tata.tutu.com`

**Composer cache**

Cache must be shared with the host to be reused when you restart the container.

`-v /var/tmp/composer:/root/.composer`


## Satis Home page

[http://127.0.0.1:3033](http://127.0.0.1:3033) (but you can map another port)

## Satis manual build

[http://127.0.0.1:3033/build](http://127.0.0.1:3033/build)

## Access Satis from outside

If you want to give access satis to the outside world, you should use a reverse proxy.

Below is a working setup for Nginx:

```
server {
    server_name satis.domain.tld;

    location / {
        proxy_pass http://127.0.0.1:3033;
    }
}
```
