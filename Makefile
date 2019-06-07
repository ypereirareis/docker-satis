.PHONY: build build-no-cache up start stop restart state remove bash satis-build

###############
## VARIABLES ##
###############
compose=docker-compose
version=5.0
image=ypereirareis/docker-satis

#############
## Targets ##
#############
build:
	docker-compose build --pull

build-no-cache:
	docker build -t $(image):$(version) --no-cache .

up:
	@echo "== START =="
	$(compose) up -d satis

start: up

stop:
	@echo "== STOP =="
	@$(compose) stop

restart: start

state:
	@echo "== STATE =="
	@$(compose) ps

remove: stop
	@echo "== REMOVE =="
	@$(compose) rm --force

bash:
	@echo "== BASH =="
	@$(compose) run --rm satis bash

logs:
	@$(compose) logs -ft

satis-build:
	@echo "== SATIS BUILD =="
	@$(compose) exec satis ./scripts/build.sh
