# SSH 設定メモ

## 1. SSH keyの作成
以下のコマンドを使用しkeyを作成.
```bash
# ssh-keygen -t rsa -b 4096 -C "コメント" -f <file name>
> ssh-keygen -t rsa -b 4096 -f k8s_main_rsa
...
# カレントディレクトリに-fで指定したファイルが作成される

> dir
...
2021/04/22  20:41    <DIR>          Downloads
2021/04/29  11:56             3,247 k8s_main_rsa
2021/04/29  11:56               734 k8s_main_rsa.pub 
...
```

## 2. .sshにディレクトリに作成したキーを格納
```bash
# 既に.sshディレクトリが存在する場合はしなくていい
> mkdir %USERPROFILE%\.ssh
# .sshに作成した鍵を入れる.
>move k8s_main_rsa %USERPROFILE%\.ssh
        1 個のファイルを移動しました。
>move k8s_main_rsa.pub %USERPROFILE%\.ssh 
        1 個のファイルを移動しました。
```


## 3. 公開鍵をクリップボードにコピー
```bash
# windowsの場合
> clip < %USERPROFILE%\.ssh\k8s_main_rsa.pub
# それ以外
> pbcopy < ~/.ssh/k8s_main_rsa.pub

```
