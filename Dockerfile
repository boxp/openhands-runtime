# ファイルパス: openhands-runtime/Dockerfile
FROM nikolaik/python-nodejs:python3.12-nodejs22

# AWS CLIのインストール
RUN apt-get update && apt-get install -y \
    python3-pip \
    unzip \
    curl \
    && pip3 install --no-cache-dir \
    awscli \
    boto3 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# AWS認証情報は、GitHub Actionsがビルド時にSSM Parameter Storeから取得し、
# ビルド時の環境変数としてコンテナに埋め込む
ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY
ARG AWS_REGION

ENV AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
ENV AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
ENV AWS_REGION=${AWS_REGION}

# エントリポイントスクリプトの追加
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"] 