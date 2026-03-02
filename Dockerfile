# Nginxの軽量版を使用
FROM nginx:alpine

# 作成者情報
LABEL maintainer="ryouya072621"

# デフォルトのNginx設定を削除
RUN rm -rf /usr/share/nginx/html/*

# HTMLファイルをコピー
COPY index.html /usr/share/nginx/html/

# カスタムNginx設定をコピー（オプション）
COPY nginx.conf /etc/nginx/conf.d/default.conf

# ポート8080を公開（GCP Cloud Runのデフォルト）
EXPOSE 8080

# ヘルスチェック
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --quiet --tries=1 --spider http://localhost:8080/ || exit 1

# Nginxを起動
CMD ["nginx", "-g", "daemon off;"]
