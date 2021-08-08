# Docker Registry:

1. Create a K8s file. [source yaml](../k8s/docker-registry.yaml)
2. apply with kubectl.
	```bash
	# Specify the file created in No.1
	> kubectl apply -f <k8s.yaml>
	```
3. Update containerd's config file.<br>[reference](https://github.com/containerd/containerd/blob/main/docs/cri/registry.md)<br>Update the containerd of the applied node as follows<br>
To force writing, do ```:w !sudo tee %``` and complete with ```:q!```
	```toml
	# /etc/containerd/config.toml
	[plugins."io.containerd.grpc.v1.cri".registry]
      [plugins."io.containerd.grpc.v1.cri".registry.mirrors]
        [plugins."io.containerd.grpc.v1.cri".registry.mirrors."docker.io"]
          endpoint = ["https://registry-1.docker.io"]
		# Add the following
        [plugins."io.containerd.grpc.v1.cri".registry.mirrors."<new name>"]
          endpoint = ["http://<hostname>:<port>"]
	```
4. Add registry information to client Docker.<br>If it is windows, add it to Json of "Docker Engine" from "Settings" of docker.
	```json
	{
	  ...
	  "insecure-registries": ["<hostname>:<port>"],
	  ...
	}
	```

# Push image test.

```bash
# Added tag to specify private repository
>docker tag hello-world <hostname>:<port>/hello-world:1.0
# push image... 
>docker push <hostname>:<port>/hello-world:1.0
The push refers to repository [<hostname>:<port>/hello-world]
f22b99068db9: Pushed
1.0: digest: sha256:1b26826f602946860c279fce658f31050cff2c596583af237d971f4629b57792 size: 525
```

