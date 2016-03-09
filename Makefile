.PHONY: build build-no-cache up start stop restart state remove bash satis-build

###############
## VARIABLES ##
###############
compose=docker-compose
version=4.1
image=ypereirareis/docker-satis

#############
## Targets ##
#############
build:
	docker build -t $(image):$(version) .

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


satis-build:
	@echo "== SATIS BUILD =="
	@$(compose) run --rm satis bash -c "cat /app/config.json && ./scripts/build.sh"
