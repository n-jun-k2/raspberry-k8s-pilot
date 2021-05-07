# User-Dataファイル

``user-data``ファイルには初期ブート時に設定されるユーザー情報等が定義されている

## SSHの設定

ラズパイを起動し、以下のコマンドでSSHの設定を行う

1. ``/etc/ssh/sshd_config``を編集する
    ```bash
    > sudo vi /etc/ssh/sshd_config
    ...
    ...
    #Port 22
    Port <Any number(Range of 49152–65535)>

    ```