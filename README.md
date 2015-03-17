# Docker Satis

A docker image and configuration to run Satis very easily in seconds:

* Automatically (cron every minute)
* Manually (http://127.0.0.1:3033/build)

**DO NOT forget to create a `config.json` file compatible with satis in your directory before starting the docker container.**

## Run the container

In this command do not forget to replace:

* HOME_DIR_PATH in `-v "HOME_DIR_PATH/.ssh/id_rsa":/var/tmp/id`
* toto.tata.tutu.com with your private repository in `-e PRIVATE_REPO_DOMAIN=toto.tata.tutu.com`

```
docker run -it -p 3033:3000 -v $(pwd):/app -v "HOME_DIR_PATH/.ssh/id_rsa":/var/tmp/id -v /var/tmp/composer:/root/.composer -e PRIVATE_REPO_DOMAIN=toto.tata.tutu.com ypereirareis/docker-satis
```

## Satis Home page

[http://127.0.0.1:3033](http://127.0.0.1:3033) (but you can map another port)

## Satis manual build

[http://127.0.0.1:3033/build](http://127.0.0.1:3033/build)
