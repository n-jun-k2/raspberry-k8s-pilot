# Edit cmdline

デフォルト設定では以下のような状態になっていて
cgroupのmemoryが無効化された状態でブートしてしまう

```
net.ifnames=0 dwc_otg.lpm_enable=0 console=serial0,115200 console=tty1 root=LABEL=writable rootfstype=ext4 elevator=deadline rootwait fixrtc
```

``cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory``を追加する

```
net.ifnames=0 dwc_otg.lpm_enable=0 console=serial0,115200 console=tty1 root=LABEL=writable rootfstype=ext4 elevator=deadline cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory rootwait fixrtc

```

## Check

```bash
>cat /proc/cgroups 

```