# Changelog

## Latest

This is always an image built based on master branch.

## v2.0.0

* `PRIVATE_REPO_DOMAIN` becomes `PRIVATE_REPO_DOMAIN_LIST` to deal with multiple private repositories.

```shell

docker run --rm -it -p 3033:3000 \
  -e PRIVATE_REPO_DOMAIN_LIST="bitbucket.org gitlab.com github.com" \
  ypereirareis/docker-satis:2.0.0

```


## v1.0.0

This is the first tagged version. It's probably the version you refered to with the `latest` tag (`ypereirareis/docker-satis:latest`) before I start versioning this image.
In this version you can use the `PRIVATE_REPO_DOMAIN` env variable with your `docker` command :

```shell

docker run --rm -it -p 3033:3000 \
  -e PRIVATE_REPO_DOMAIN=toto.tata.tutu.com \
  ypereirareis/docker-satis:1.0.0

```

In the next version, probably v2.0.0 (because of BC), `PRIVATE_REPO_DOMAIN` becomes `PRIVATE_REPO_DOMAIN_LIST` to deal with multiple private repositories.
