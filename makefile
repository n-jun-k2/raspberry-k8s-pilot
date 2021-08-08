TOOLS_GOLANG_SERVICE_NAME := golang


.PHONY: bash
bash:
	@cd tools && \
	docker-compose run --rm --entrypoint "/bin/bash" kube

.PHONY: kubectl
kubectl:
	@cd tools && \
	docker-compose run --rm --entrypoint "kubectl" kube ${cmd}

.PHONY: skaffold
skaffold:
	@cd tools && \
	docker-compose run --rm --entrypoint "skaffold" kube ${cmd}

.PHONY: k9s
k9s:
	@cd tools && \
	docker-compose run --rm kube

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
