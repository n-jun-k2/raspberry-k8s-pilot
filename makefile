TOOLS_GOLANG_SERVICE_NAME := golang

.PHONY: terraform
terraform:
	@docker-compose run --rm tf ${CMD}


.PHONY: tf-init
tf-init:
	@make terraform CMD=init
.PHONY: tf-plan
tf-plan:
	@make terraform CMD=plan
.PHONY: tf-destroy
tf-destroy:
	@make terraform CMD=destroy
.PHONY: tf-apply
tf-apply:
	@make terraform CMD=apply

tf-devplan:
	@make terraform CMD="plan -var-file=dev.tfvars"
tf-devapply:
	@make terraform CMD="apply -var-file=dev.tfvars"
tf-devdestroy:
	@make terraform CMD="destroy -var-file=dev.tfvars"


.PHONY: build-tools
build-tools:
	cd tools &&\
	docker-compose --env-file ../.env up -d --build

.PHONY: login-tools
login-tools:
	cd tools &&\
	docker-compose exec ${TOOLS_GOLANG_SERVICE_NAME} /bin/bash

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

.PHONY: network-conf
network-conf:
	- del .\tools\project\network-config
	make run-tools CMD=create_network_conf
	copy .\tools\project\network-config .\config\network-config

.PHONY: prune
prune:
	docker system prune


.PHONY: setconfig
setconfig:
	kubectl config set-context ${name} --namespace=${space} --cluster=kubernetes --user=kubernetes-admin

.PHONY: useconfig
useconfig:
	kubectl config use-context ${name}

.PHONY: showconfig
showconfig:
	kubectl config get-contexts
