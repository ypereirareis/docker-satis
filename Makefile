.PHONY: build up start stop restart state remove bash satis-build down logs

###############################################
##     VARIABLES                             ##
###############################################
compose=docker-compose
image=ypereirareis/docker-satis

###############################################
##      TARGETS                              ##
###############################################
up:
	@echo "== START =="
	$(compose) up -d satis

start: up

build:
	@$(compose) build --pull

rebuild:
	@$(compose) build --pull --no-cache

stop:
	@echo "== STOP =="
	@$(compose) stop

restart: start

state:
	@echo "== STATE =="
	@$(compose) ps

remove:
	@echo "== REMOVE =="
	@$(compose) rm --force

bash:
	@echo "== BASH =="
	@$(compose) exec satis bash

logs:
	@$(compose) logs -ft --tail=1000

down:
	@$(compose) down --volumes --remove-orphans

satis-build:
	@echo "== SATIS BUILD =="
	@$(compose) exec satis ./scripts/build.sh
