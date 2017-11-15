BASE_DIR = $(dir $(abspath $(firstword $(MAKEFILE_LIST))))

.PHONY: prune rmvolumes rmcontainers rmimages stop nuke build up

CONTAINERS = `docker container ls -a -q`
VOLUMES = `docker volume ls -q`
IMAGES = `docker images -q`

all:
	@echo "Hon hon hon! Feed me le parameter"
	@echo "'make help' for available parameters"

help:		## Show this help
	@echo
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'
	@echo

migrate:	## Run django database migrations
	@docker-compose exec app ./manage.py migrate

createsuperuser:## Create django database superuser
	@docker-compose exec app ./manage.py createsuperuser

collectstatic:	## Collect static css/js files needed by django project
	@docker-compose exec app ./manage.py collectstatic --noinput --clear

shellplus:	## Run django_extensions shell_plus inside container
	@docker-compose exec app ./manage.py shell_plus

prune:		## Remove unused dangling data
	@docker system prune --force

pruneall:	## Remove all unused data
	@docker system prune --all --force

rmvolumes:	## Removes all volumes systemwide
	@if [ "$(VOLUMES)" != "" ]; then \
	echo "Removing volumes: $(VOLUMES)"; \
	docker volume rm $(shell docker volume ls -q); \
	fi

rmcontainers:	## Removes all containers systemwide
	@if [ "$(CONTAINERS)" != "" ]; then \
	echo "Removing containers: $(CONTAINERS)"; \
	docker rm $(shell docker container ls -a -q); \
	fi

rmimages:	## Removes all images systemwide
	@if [ "$(IMAGES)" != "" ]; then \
	echo "Removing images: $(IMAGES)"; \
	docker rmi $(shell docker images -q); \
	fi

stop:		## Stops all running containers
	@if [ "$(CONTAINERS)" != "" ]; then \
	echo "Stopping containers: $(CONTAINERS)"; \
	docker container stop $(shell docker ps -a -q); \
	fi

wipe: stop rmcontainers rmvolumes

nuke: stop rmcontainers rmimages rmvolumes

build:		## Build docker images
	@docker-compose build

up:		## Run docker container
	@docker-compose up
