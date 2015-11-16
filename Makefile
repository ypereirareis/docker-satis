compose=docker-compose

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

