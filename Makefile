check: .env docker-compose.override.yml src
	docker version
	docker-compose version
	docker-compose config

help:
	@echo
	@echo "Available commands:"
	@echo
	@echo "  check      : Check and print final docker compose configuration."
	@echo "  build      : (Re-)build containers."
	@echo "  up         : Run containers in this terminal."
	@echo "  bash       : Start a shell on the php container with the magento user."
	@echo "  flush-cache: Flush redis cache."
	@echo "  xdebug-on  : Enable xdebug (requires restarting the stack for php web)."
	@echo "  xdebug-off : Disable xdebug (requires restarting the stack for php web)."
	@echo "  clear      : Clear containers and associated volumes."
	@echo "  help       : Display this help."
	@echo


.env:
	./initenv.sh

docker-compose.override.yml:
	cp -v docker-compose.override.sample.yml docker-compose.override.yml

src:
	mkdir -pv src
	touch src/nginx.conf.sample

build: check
	docker-compose build

up: check
	docker-compose up

bash:
	docker-compose exec -u magento php-fpm bash

flush-cache:
	docker-compose exec redis redis-cli flushall

xdebug-on:
	docker-compose exec php-fpm phpenmod xdebug
xdebug-off:
	docker-compose exec php-fpm phpdismod xdebug

clear:
	docker-compose down --volumes
