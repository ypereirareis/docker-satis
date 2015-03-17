# docker-satis

A docker image and configuration to run Satis very easily in seconds.

**DO NOT forget to create a config.json or satis.json file compatible with satis in your directory before starting the docker container.**


## Command

```
docker run -it -v $(pwd):/app -v "HOME_DIR_PATH/.ssh/id_rsa":/var/tmp/id -v /var/tmp/composer:/root/.composer -e PRIVATE_REPO_DOMAIN=toto.tata.com ypereirareis/docker-satis
```
