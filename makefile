TOOLS_GOLANG_SERVICE_NAME := golang
TOOLS_TERRAFORM_SERVICE_NAME := tf

.PHONY: build-tools
build-tools:
	cd tools &&\
	docker-compose --env-file ../.env up -d --build

.PHONY: down
down:
	cd tools && \
	docker-compose down

.PHONY: login-tools-go
login-tools-go:
	cd tools &&\
	docker-compose exec ${TOOLS_GOLANG_SERVICE_NAME} /bin/bash


.PHONY: login-tools-tf
login-tools-tf:
	cd tools &&\
	docker-compose exec ${TOOLS_TERRAFORM_SERVICE_NAME} ash

.PHONY: clean-tools
clean-tools:
	- cd tools &&\
	docker-compose down &&\
	docker volume rm pkg_store &&\
	docker volume rm bin_store

.PHONY: run-tools
run-tools:
	cd tools &&\
	docker-compose exec ${TOOLS_GOLANG_SERVICE_NAME} /bin/bash -c "go run ./cmd/${CMD}/main.go"

.PHONY: user-data
user-data:
	- del .\tools\project\user-data
	make run-tools CMD=create_user_data
	copy .\tools\project\user-data .\config\user-data

.PHONY: prune
prune:
	docker volume prune
	docker network prune
