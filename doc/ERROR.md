# Error list

- cgroupのmemoryが無効化されてしまう。
    ```bash
    root@ubuntu:~# kubeadm init
    I0114 21:36:08.472296   43945 version.go:252] remote version is much newer: v1.20.      2; falling back to: stable-1.18
    W0114 21:36:09.136318   43945 configset.go:202] WARNING: kubeadm cannot validate        component configs for API groups[kubelet.config.k8s.io kubeproxy.config.k8s.io]
    [init] Using Kubernetes version: v1.18.15
    [preflight] Running pre-flight checks
    [preflight] The system verification failed. Printing the output from the        verification:
    KERNEL_VERSION: 5.4.0-1026-raspi
    CONFIG_NAMESPACES: enabled
    CONFIG_NET_NS: enabled
    CONFIG_PID_NS: enabled
    CONFIG_IPC_NS: enabled
    CONFIG_UTS_NS: enabled
    CONFIG_CGROUPS: enabled
    CONFIG_CGROUP_CPUACCT: enabled
    CONFIG_CGROUP_DEVICE: enabled
    CONFIG_CGROUP_FREEZER: enabled
    CONFIG_CGROUP_SCHED: enabled
    CONFIG_CPUSETS: enabled
    CONFIG_MEMCG: enabled
    CONFIG_INET: enabled
    CONFIG_EXT4_FS: enabled
    CONFIG_PROC_FS: enabled
    CONFIG_NETFILTER_XT_TARGET_REDIRECT: enabled (as module)
    CONFIG_NETFILTER_XT_MATCH_COMMENT: enabled (as module)
    CONFIG_OVERLAY_FS: enabled (as module)
    CONFIG_AUFS_FS: enabled (as module)
    CONFIG_BLK_DEV_DM: enabled
    OS: Linux
    CGROUPS_CPU: enabled
    CGROUPS_CPUACCT: enabled
    CGROUPS_CPUSET: enabled
    CGROUPS_DEVICES: enabled
    CGROUPS_FREEZER: enabled
    CGROUPS_MEMORY: missing
    error execution phase preflight: [preflight] Some fatal errors occurred:
            [ERROR SystemVerification]: missing cgroups: memory
    [preflight] If you know what you are doing, you can make a check non-fatal with         `--ignore-preflight-errors=...`
    To see the stack trace of this error execute with --v=5 or higher
    ```
    [対応策](CMDLINE.md)

- kubeadmのインストール＆セットアップ直後は、再起動が必要。
    特に以下のような状態の時はrebootで改善される。
  ```
    root@k8s-master-0001:~# kubectl get nodes
	NAME              STATUS     ROLES    AGE     VERSION
	k8s-master-0001   NotReady   master   2m42s   v1.18.2
	k8s-worker-0001   NotReady   <none>   111s    v1.18.2

    root@k8s-master-0001:~# systemctl status kubelet
    ● kubelet.service - kubelet: The Kubernetes Node Agent
         Loaded: loaded (/lib/systemd/system/kubelet.service; enabled; vendor   preset: enabled)
        Drop-In: /etc/systemd/system/kubelet.service.d
                 └─10-kubeadm.conf
         Active: active (running) since Thu 2021-05-06 20:54:16 JST; 12min ago
           Docs: https://kubernetes.io/docs/home/
       Main PID: 44046 (kubelet)
          Tasks: 19 (limit: 4436)
         Memory: 43.9M
         CGroup: /system.slice/kubelet.service
                 └─44046 /usr/bin/kubelet --bootstrap-kubeconfig=/etc/  kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/  kubernetes/kubelet.conf --confi>
     5月 06 20:56:49 k8s-master-0001 kubelet[44046]: E0506 20:56:49.402966      44046 kubelet.go:2187] Container runtime network not ready:    NetworkReady=fal> 5月 06 20:56:54 k8s-master-0001 kubelet[44046]: E0506    20:56:54.404334   44046 kubelet.go:2187] Container runtime network not     ready: NetworkReady=fal> 5月 06 20:56:59 k8s-master-0001 kubelet[44046]:    E0506 20:56:59.405568   44046 kubelet.go:2187] Container runtime network   not ready: NetworkReady=fal> 5月 06 20:57:04 k8s-master-0001 kubelet  [44046]: E0506 20:57:04.406979   44046 kubelet.go:2187] Container     runtime network not ready: NetworkReady=fal> 5月 06 20:57:05    k8s-master-0001 kubelet[44046]: W0506 20:57:05.998427   44046 manager. go:1131] Failed to process watch event {EventType:0 Name:/kube> 5月 06   20:57:24 k8s-master-0001 kubelet[44046]: I0506 20:57:24.355691   44046    topology_manager.go:233] [topologymanager] Topology Admit Handler      
     5月 06 20:57:24 k8s-master-0001 kubelet[44046]: I0506 20:57:24.456094      44046 reconciler.go:224] operationExecutor.    VerifyControllerAttachedVolume st> 5月 06 20:57:24 k8s-master-0001  kubelet[44046]: I0506 20:57:24.456231   44046 reconciler.go:224]     operationExecutor.VerifyControllerAttachedVolume st> 5月 06 20:59:24    k8s-master-0001 kubelet[44046]: E0506 20:59:24.325549   44046 machine. go:331] failed to get cache information for node 0: open /sys/> 5月 06   21:04:24 k8s-master-0001 kubelet[44046]: E0506 21:04:24.325044   44046    machine.go:331] failed to get cache information for node 0: open /sys/>~
    ```
