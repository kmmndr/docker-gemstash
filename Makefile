all: help
include *.mk

start: docker-compose-start ##- Start
deploy: docker-compose-deploy ##- Deploy (start remotely)

gemstash: environment
	$(load_env); docker-compose exec gemstash /bin/ash
