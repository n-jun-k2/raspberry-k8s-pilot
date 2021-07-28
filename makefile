TOOLS_GOLANG_SERVICE_NAME := golang

.PHONY: sh
sh:
	@cd tools && \
	docker-compose run --rm --entrypoint "/bin/sh" terragrunt

.PHONY: terraform
terraform:
	@cd tools && \
	docker-compose run --rm --entrypoint "terraform"  terragrunt "$(if ${dir}, -chdir=./terraform.tfstate.d/${dir}) ${cmd} $(if ${dir}, -var-file=${dir}.tfvars)"

.PHONY: terragrunt
terragrunt:
	@cd tools && \
	docker-compose run --rm terragrunt ${cmd}

.PHONY: workspace-%
workspace-%:
	@cd tools && \
	make terraform cmd="workspace new $*" && \
	make sh cmd="touch ./terraform.tfstate.d/$*/valiables.tf" && \
	make sh cmd="touch ./terraform.tfstate.d/$*/$*.tfvars" && \
	make terraform dir=$* cmd=init

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
