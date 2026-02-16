#!/bin/bash
# Rode este script na pasta "Empreendimento Jardini" para subir no Git.
# Uso: abra o Terminal, vá até a pasta e execute: bash subir-no-git.sh

set -e
cd "$(dirname "$0")"

echo "→ Inicializando repositório Git..."
git init

echo "→ Adicionando arquivos..."
git add .

echo "→ Primeiro commit..."
git commit -m "Site Jardine Residence — apresentação estática"

echo ""
echo "✓ Repositório criado com sucesso."
echo ""
echo "Próximos passos:"
echo "1. Crie um repositório novo no GitHub (github.com → New repository)."
echo "   Ex.: nome = jardine-residence"
echo "2. Rode no Terminal (troque SEU_USUARIO pelo seu usuário do GitHub):"
echo ""
echo "   git remote add origin https://github.com/SEU_USUARIO/jardine-residence.git"
echo "   git branch -M main"
echo "   git push -u origin main"
echo ""
echo "3. Para publicar: Vercel (vercel.com) ou GitHub Pages (Settings → Pages no repo)."
echo "   Detalhes em jardine/DEPLOY.md"
