.PHONY: \
	docker-up

.DEFAULT: docker-up

CURRENT_UID=$(shell id -u)
CURRENT_GID=$(shell id -g)

docker-up: docker-compose.override.yml _config_dev.yml
	CURRENT_UID=$(CURRENT_UID) CURRENT_GID=$(CURRENT_GID) docker-compose up

docker-compose.override.yml:
	cp docker-compose.override.yml-dist docker-compose.override.yml

_config_dev.yml:
	cp _config_dev.yml-dist _config_dev.yml
