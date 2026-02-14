#!/bin/bash
# Sobe o vídeo usando Git LFS.
# Pré-requisito: brew install git-lfs (e depois: git lfs install)

set -e
cd "$(dirname "$0")"

VIDEO="4. Vídeo das alturas/capitali_-_jardine__(5) (1080p)_alt3.mp4"

if ! git lfs version &>/dev/null; then
  echo "Git LFS não está instalado. Instale com:"
  echo "  brew install git-lfs"
  echo "  git lfs install"
  exit 1
fi

if [[ ! -f "$VIDEO" ]]; then
  echo "Arquivo não encontrado: $VIDEO"
  exit 1
fi

echo "Configurando Git LFS no repositório..."
git lfs install

echo "Adicionando .gitattributes e vídeo..."
git add .gitattributes .gitignore
git add "$VIDEO"

echo "Status:"
git status

echo ""
read -p "Fazer commit e push? (s/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Ss]$ ]]; then
  git commit -m "Adicionar vídeo das alturas via Git LFS"
  git push origin main
  echo "Concluído."
else
  echo "Commit/push cancelado. Você pode fazer manualmente:"
  echo "  git commit -m \"Adicionar vídeo das alturas via Git LFS\""
  echo "  git push origin main"
fi
