NAME = inception
DOCKER_COMPOSE = docker-compose -f srcs/docker-compose.yml

all: build up

build:
	mkdir -p /home/ggaribot/data/wordpress
	mkdir -p /home/ggaribot/data/mariadb
	$(DOCKER_COMPOSE) build

up:
	$(DOCKER_COMPOSE) up -d

down:
	$(DOCKER_COMPOSE) down

clean: down
	docker rmi -f $$(docker images -q)
	docker volume rm $$(docker volume ls -q)
	sudo rm -rf /home/ggaribot/data/wordpress/*
	sudo rm -rf /home/ggaribot/data/mariadb/*

fclean: clean
	docker system prune -af

re: fclean all

.PHONY: all build up down clean fclean re