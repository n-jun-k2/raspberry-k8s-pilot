# NETWORK

## 設定方法
設定方法には2つの方法が存在します。

1. 初期起動前に設定を行う
2. 初期起動後に設定を行う


## 初期起動前の設定方法
``network-config``ファイルを編集します。
デフォルトでは以下のような設定になっています。
```
# This file contains a netplan-compatible configuration which cloud-init
# will apply on first-boot. Please refer to the cloud-init documentation and
# the netplan reference for full details:
#
# https://cloudinit.readthedocs.io/
# https://netplan.io/reference
#
# Some additional examples are commented out below

version: 2
ethernets:
  eth0:
    dhcp4: true
    optional: true
#wifis:
#  wlan0:
#    dhcp4: true
#    optional: true
#    access-points:
#      myhomewifi:
#        password: "S3kr1t"
#      myworkwifi:
#        password: "correct battery horse staple"
#      workssid:
#        auth:
#          key-management: eap
#          method: peap
#          identity: "me@example.com"
#          password: "passw0rd"
#          ca-certificate: /etc/my_ca.pem

```

wifiで設定を行う場合以下のような対応を行います。

最小限の設定
```
wifis:
  wlan0:
    dhcp4: false
    optional: true
    access-points:
        "SSID":
            password: "password"
```
IPを固定したい場合は以下のようにする
```
wifis:
  wlan0:
    dhcp4: false
    dhcp6: false
    optional: true
    addresses: [192.168.XX.YY/24] # IPアドレスを固定化
    gateway4: 192.168.XX.1 # ルータのアドレス
    nameservers:
      addresses: [192.168.XX.1] # ルータのアドレス
      search: []
    access-points:
        "SSID":
            password: "password"
```

## 初期設定後の設定方法
 ``/etc/netplan/50-cloud-init.yaml``ファイルにネットワーク設定が反映されている為このファイルを編集します。

編集内容は設定前の方法と同じな為省略。

```bash
> sudo vi /etc/netplan/50-cloud-init.yaml

version: 2
ethernets:
  eth0:
    dhcp4: true
    optional: true
    ...
```

編集後に以下の用に反映を行う。

```bash
> sudo netplan --debug try
> sudo netplan --debug generate
> sudo netplan --debug apply

> sudo reboot
```