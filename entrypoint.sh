#!/bin/bash
set -e

# AWS認証情報はビルド時に環境変数として埋め込まれているため、
# ここでは追加の設定は不要

# AWS認証情報はビルド時に埋め込まれているため、実行時に確認するだけ
if [ -n "$AWS_ACCESS_KEY_ID" ] && [ -n "$AWS_SECRET_ACCESS_KEY" ]; then
  echo "AWS credentials are configured"
  
  # リージョン設定
  if [ -n "$AWS_REGION" ]; then
    mkdir -p ~/.aws
    cat > ~/.aws/config << EOF
[default]
region = $AWS_REGION
EOF
    echo "AWS region configured: $AWS_REGION"
  fi
  
  # SSM Parameter Storeへのアクセスをテスト
  echo "Testing SSM Parameter Store access..."
  aws ssm get-parameter --name parameter-reader-access-key-id --query "Parameter.Name" --output text || echo "Warning: SSM Parameter Store access failed"
fi

# 元のエントリポイントコマンドを実行
exec "$@" 