# K8s memo:

kubernetesの主な機能

| name | override |
| --- | --- |
| スケーリング/オートスケーリング | コンテナクラスタを形成し、複数のNodeを管理します。 |
| スケジューリング | コンテナをデプロイする際、どのNodeに配置するかを決定する。（例、「ディスクIOが多い」コンテナを「ディスクがSSD」のNodeに配置する。 |
| リソース管理 | コンテナ配置の為の特別な指定がない場合には、NodeのCPUやメモリの秋リソースの状況に従ってスケジューリングが行われる。その為ユーザーが意識する必要がありません。 |
| セルフヒーリング | 標準でコンテナのプロセス監視が行われている。プロセスの停止を検知すると、再度コンテナのスケジューリングを実行することで自動的にコンテナを再デプロイします。クラスタのNode障害が起きたり、Node退避を行ったりして、Node上のコンテナが失われた場合であっても、サービスに影響なくアプリケーションを自動復旧を行います。 |
| サービスディスカバリとロードバランシング | コンテナをスケーリングさせた場合、アプリケーションへ接続するためのエンドポイントの問題を解消する為、ロードバランシング機能（Service）があらかじめ指定した条件に合致するコンテナ群に対してルーティングを行う機能を提供します。また、Serviceを利用することでサービスディスカバリを行うことも可能です。 |
| データの管理 | データストアにetcdを採用しています。etcdはクラスタを組むことで冗長化ができる為、コンテナやServiceに関するマニフェストも冗長化された保存されています。kubernetesにはコンテナが利用する設定ファイルや認証情報などのデータを保存する仕組みが用意されています。 |

## 始めてみよう

コンテナのデプロイからサービスの外部公開するまで、Kubernetesではたったの2ステップです。


今回はnginexのサーバーのコンテナを3つ起動しロードバランサーを紐づけし外部公開を行います。

ロードバランサーを作成するとサービス公開に必要なIPアドレスが払いだされる。自動的に3つのコンテナへの負荷分散された状態になります。

```bash
# nginxコンテナ3つからなるグループを作成しmyappラベルもつけておく
> kubectl run myapp \
	--image=nginx:1.12 \
	--replicas 3 \
	--labels="app=myapp"

> kubectl create service loadbalancer \
	--tcp 80:80 myapp

# 外部アクセスする為のIP Addressを取得
> kubectl get service myapp

```

# Resources...

| 種別 |　概要 |
| --- | --- |
| Workloads | コンテナの実行に関するリソース |
| Discovery & LB | コンテナを外部公開するようなエンドポイントを提供するリソース |
| Config & Storage | 設定/機密情報/永続化ボリュームなどに関するリソース |
| Cluster | セキュリティやクォーターなどに関するリソース |
| Metadata | クラスタ内の他のリソースを操作するためのリソース |


## Workloads リソース
クラスタ上にコンテナを起動させるために利用するリソース。
- Pod
- ReplicationController
- ReplicaSet
- Deployment
- DaemonSet
- Job
- CronJob

## Discovery & LB リソース
コンテナのサービスディスカバリ、クラスタの外部からもアクセス可能なエンドポイントなどを提供するリソース。
- Service
  - ClusterIP
  - ExternalIP
  - NodePort
  - LoadBalancer
  - Headless
  - ExternalName
  - None-Selector
- Ingress

## Config & Storage リソース
設定や機密データをコンテナに埋め込んだり、永続ボリュームを提供するリソース。
- Secret
- ConfigMap
- PersistentVolumeClaim

## Clusterリソース
クラスタ自体の振る舞いを定義するリソース
- Node
- Namespace
- PersistentVolume
- ResourceQuota
- ServiceAccount
- Role
- ClusterRole
- RoleBinding
- ClusterRoleBinding
- NetworkPolicy

## Metadataリソース
クラスタ内の他のリソースの動作を制御するためのリソース
- LimitRange
- HorizontalPodAutoscaler
- PodDisruptionBudget
- CustomResourceDefinition

# Namesapceによる仮想的なクラスタの分離
Kubernetesクラスタを複数チームで利用したり、プロダクション環境/ステージング環境/開発環境などのように、環境ごとに分割したりすることが可能です。
- kube-system
  - KubernetesクラスタのコンポーネントやアドオンがデプロイされるNamespace(システムコンポーネントやアドオンなど)
- kube-public
  - 全ユーザが利用できるConfigMapなどを配置するNamespace（全ユーザ共通の設定など)
- default
  - デフォルトのNamespace


# 認証情報とContext（Config）
kubectlはkubeconfig(デフォルトでは「~/.kube/config」)に書かれている情報を使用して接続を行います。

```yaml
apiVersion: v1
kind: Config
preferences: {}
clusters: # 接続先クラスタ
  - name: example-cluster
    cluster:
	  server: ...
users: # 認証情報
  - name: example-user
    user:
	  client-certificate-data: IEFIJ...
	  client-key-data: OJIFE...
contexts: # 接続先と認証情報の組み合わせ
  - name: example-context
    context:
	  cluster: example-cluster
	  namespace: default
	  user: example-user
current-context: example-context
```

clusters/users/contextの3種類です。これらの3種類の設定項目はいずれも配列型となっており、複数の対称を登録することができます。

### cluster
接続先クラスタの情報。
### users
認証情報の定義。認証には、X.509クライアント証明書/トークン/パスワード/Webhookなど様々な方式が利用できるようになっている。
### context
clusterとuserのペアとnamespaceを指定したもの定義。

## kubeconfigの変更

```bash
# クラスタの定義
> kubectl config set-cluster prd-cluster \
  --server=https://localhost:6643

# 認証情報の定義
> kubectl config set-credentials admin-user \
  --client-certificate=./sample.crt \
  --client-key=./sample.key \
  --embed-certs=true

# Contextの定義（クラスタ/認証情報/Namespaceを定義）
> kubectl config set-context prd-admin \
  --cluster=prd-cluster \
  --user=admin-user \
  --namespace=default

# Contextの切り替え
> kubectl config use-context prd-admin

# 現在のContextを表示
> kubectl config current-context

# コマンドの実行ごとにContextを指定することも可能
> kubectl --context prd-admin get pod

```
