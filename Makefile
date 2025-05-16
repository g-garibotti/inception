COMPOSE := docker compose -f srcs/docker-compose.yml

DATA_DIR   := $(HOME)/data
MARIADB_DIR := $(DATA_DIR)/mariadb
WP_DIR     := $(DATA_DIR)/wordpress

.PHONY: all up down delete clean log re

all: up

up:
	@mkdir -p $(MARIADB_DIR) $(WP_DIR)
	@$(COMPOSE) up --build -d

down:
	@$(COMPOSE) down

delete:
	@sudo rm -rf $(DATA_DIR)/*

clean: delete
	-@docker stop $$(docker ps -qa)
	-@docker rm   $$(docker ps -qa)
	-@docker rmi -f $$(docker images -qa)
	-@docker volume rm $$(docker volume ls -q)
	-@docker network rm $$(docker network ls -q) 2>/dev/null

log:
	@$(COMPOSE) logs

re: clean all
