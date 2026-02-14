# Jardine Residence — Site de apresentação

Site estático do empreendimento Jardine Residence (Capitali).  
PT e ES · Plantas, vídeo, galeria, forma de pagamento, localização e corretora.

## Rodar localmente

Abra `site/index.html` no navegador. O site precisa estar dentro da pasta **Empreendimento Jardini** (junto das pastas 1–7 e da foto da corretora) para os links relativos funcionarem.

## Subir no Git e publicar

### Opção 1 — Script (recomendado)

No **Terminal**, na pasta **Empreendimento Jardini**:

```bash
cd "/Users/douglasrinckus/Downloads/Empreendimento Jardini"
bash subir-no-git.sh
```

Depois crie o repositório no GitHub (New repository → ex.: `jardine-residence`) e rode:

```bash
git remote add origin https://github.com/SEU_USUARIO/jardine-residence.git
git branch -M main
git push -u origin main
```

(Substitua `SEU_USUARIO` pelo seu usuário do GitHub.)

### Opção 2 — Comandos manualmente

```bash
cd "/Users/douglasrinckus/Downloads/Empreendimento Jardini"
git init
git add .
git commit -m "Site Jardine Residence"
# Depois: criar o repo no GitHub e fazer git remote add + git push (como acima)
```

## Onde publicar o site

- **Vercel** (vercel.com): Import Project → escolha o repositório. Ver `site/DEPLOY.md`.
- **GitHub Pages**: no repositório, **Settings** → **Pages** → Source: **Deploy from a branch** → branch **main** → pasta **/ (root)**. O site ficará em `https://SEU_USUARIO.github.io/jardine-residence/`.  
  (Para o Pages funcionar com as pastas de mídia, o `index.html` e as pastas 1–7 precisam estar na raiz do repo; ver detalhes em `site/DEPLOY.md`.)

**Sim, o GitHub também permite publicar o site** usando GitHub Pages, de graça.
