# -WEB- 管理アプリ

シンプルな「表示完了」メッセージを表示するWebアプリケーション。
Docker + GCP Cloud Runでデプロイ可能。

## 📋 目次

- [概要](#概要)
- [技術スタック](#技術スタック)
- [ローカル開発](#ローカル開発)
- [GCPへのデプロイ](#gcpへのデプロイ)
- [プロジェクト構成](#プロジェクト構成)

## 🎯 概要

このアプリケーションは「表示完了」というメッセージを表示するシンプルなWebアプリです。
Dockerコンテナ化されており、Google Cloud Platform (GCP) のCloud Runで簡単にデプロイできます。

## 🛠 技術スタック

- **Webサーバー**: Nginx (Alpine Linux)
- **コンテナ**: Docker
- **デプロイ先**: GCP Cloud Run
- **CI/CD**: GCP Cloud Build

## 💻 ローカル開発

### 前提条件

- Docker Desktop がインストールされていること

### Dockerで起動

```bash
# イメージをビルド
docker build -t web-app .

# コンテナを起動
docker run -p 8080:8080 web-app

# ブラウザで開く
# http://localhost:8080
```

### 停止

```bash
# 実行中のコンテナを確認
docker ps

# コンテナを停止
docker stop <CONTAINER_ID>
```

## ☁️ GCPへのデプロイ

### 方法1: 手動デプロイ

#### 1. GCP CLIのインストールと認証

```bash
# Google Cloud SDKをインストール（未インストールの場合）
# https://cloud.google.com/sdk/docs/install

# 認証
gcloud auth login

# プロジェクトを設定
gcloud config set project YOUR_PROJECT_ID
```

#### 2. Cloud Run APIを有効化

```bash
gcloud services enable run.googleapis.com
gcloud services enable cloudbuild.googleapis.com
```

#### 3. デプロイ

```bash
# イメージをビルドしてCloud Runにデプロイ
gcloud run deploy web-app \
  --source . \
  --region asia-northeast1 \
  --platform managed \
  --allow-unauthenticated \
  --port 8080

# デプロイ完了後、URLが表示されます
# 例: https://web-app-xxxxx-an.a.run.app
```

### 方法2: GitHub連携で自動デプロイ

#### 1. Cloud Buildトリガーを設定

```bash
# GitHubリポジトリと連携
gcloud beta builds triggers create github \
  --repo-name=-WEB- \
  --repo-owner=ryouya072621-gif \
  --branch-pattern="^main$" \
  --build-config=cloudbuild.yaml
```

#### 2. GitHubにプッシュすると自動デプロイ

```bash
git add .
git commit -m "Initial commit"
git push origin main
```

### デプロイ後の確認

```bash
# サービスの状態を確認
gcloud run services describe web-app --region asia-northeast1

# ログを確認
gcloud run services logs read web-app --region asia-northeast1
```

## 📁 プロジェクト構成

```
-WEB-/
├── index.html           # メインHTML（表示完了メッセージ）
├── Dockerfile          # Dockerイメージ定義
├── nginx.conf          # Nginx設定（ポート8080、ヘルスチェック）
├── .dockerignore       # Docker除外ファイル
├── cloudbuild.yaml     # GCP Cloud Build設定
└── README.md           # このファイル
```

## 🔧 カスタマイズ

### メッセージを変更する

[index.html](index.html) の `<h1>表示完了</h1>` 部分を編集してください。

### ポート番号を変更する

以下のファイルで `8080` を変更してください：
- [Dockerfile](Dockerfile) の `EXPOSE` 行
- [nginx.conf](nginx.conf) の `listen` 行
- [cloudbuild.yaml](cloudbuild.yaml) の `--port` 引数

### リージョンを変更する

[cloudbuild.yaml](cloudbuild.yaml) の `--region asia-northeast1` を変更してください。

利用可能なリージョン:
- `asia-northeast1` - 東京
- `asia-northeast2` - 大阪
- `us-central1` - アイオワ
- `europe-west1` - ベルギー

## 📝 ライセンス

MIT License

## 👤 作成者

ryouya072621-gif