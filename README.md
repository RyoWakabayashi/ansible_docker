# Ansible on Docker

開発環境が Windows である場合、Ansible が実行できない

そのため、Docker 上に Ansible の環境を構築して実行する

また、プロキシサーバー経由でインターネットに接続している場合、
Docker のビルド時や Ansible の実行時、実行先のサーバーにプロキシの設定が必要になる

当リポジトリーでは、Docker 上での Ansible によるプロキシ経由での構成管理の実行例を示す

## 実行内容

ssh-config ファイルで指定したターゲットのサーバー（CentOS）に以下のプロキシ設定を施す

- yum
- 環境変数
- curl

## 実行環境

- OS: Windows
- ネットワーク: プロキシサーバー経由で外部に接続する

### 必要なツール

- [Docker]
- [Docker Compose][compose]

## 事前準備

### リポジトリのクローン

```clone
cd && git clone https://github.com/oecdx/ansible_docker.git \
  && cd ansible_docker
```

### 環境変数の設定

プロキシーを環境変数に設定すること

- HTTP_PROXY
- HTTPS_PROXY

### 設定ファイルのコピー・編集

- ssh-config

  sample ファイルをコピーする

  ```ps
  cp ssh-config.sample ssh-config
  ```

  SSH 接続時のホスト名、ユーザー名を指定する

- hosts

  sample ファイルをコピーする

  ```ps
  cp hosts.sample ./playbooks/hosts
  ```

  SSH 接続時のユーザー名、パスワード、管理者実行用のパスワードを指定する

## コンテナのビルド

ビルド時にプロキシを指定する

```ps
docker-compose build `
  --build-arg HTTP_PROXY=$env:HTTP_PROXY `
  --build-arg HTTPS_PROXY=$env:HTTPS_PROXY
```

## コンテナの起動

```ps
docker-compose up -d
```

## docker コンテナへの接続

ansible を実行するため、コンテナに接続する

```ps
docker exec -it ansible /bin/bash
```

## ディレクトリーの移動

playbook のあるディレクトリーに移動する

以降のコマンドはコンテナ内で実行する

```bash
cd playbooks
```

## ssh 接続の確認

SSH 接続時に接続先を認証する必要があるため、 `ssh` コマンドで一度接続する

```bash
$ ssh target-server
The authenticity of host 'x.x.x.x (x.x.x.x)' can't be established.
ECDSA key fingerprint is SHA256:xxx.
ECDSA key fingerprint is MD5:xxx.
Are you sure you want to continue connecting (yes/no)?
```

ホストに接続するか確認されるので `yes` を入力する

パスワードを入力して接続できたら SSH を切断する

```bash
exit
```

## playbook の実行

```bash
ansible-playbook -i hosts playbook.yml
```

[docker]: https://www.docker.com/
[compose]: https://docs.docker.com/compose/
