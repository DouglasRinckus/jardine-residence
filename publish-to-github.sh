#!/bin/bash
# Publicar projeto no GitHub
# 1. Autentique antes: gh auth login
# 2. Execute: ./publish-to-github.sh

set -e
cd "$(dirname "$0")"

REPO_NAME="jardine-residence"
GITHUB_USER="douglasrinckus"

echo "Verificando autenticação GitHub..."
if ! gh auth status &>/dev/null; then
  echo "Erro: faça login primeiro com: gh auth login"
  exit 1
fi

echo "Criando repositório no GitHub e publicando..."
if gh repo create "$GITHUB_USER/$REPO_NAME" --public --source=. --remote=origin --push 2>/dev/null; then
  echo "Repositório criado e código enviado."
else
  echo "Repositório já existe ou outro erro. Tentando apenas push..."
  git push -u origin main
fi

echo "Concluído. Repositório: https://github.com/$GITHUB_USER/$REPO_NAME"
