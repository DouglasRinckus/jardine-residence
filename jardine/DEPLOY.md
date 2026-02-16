# Publicar o site (Vercel + domínio)

## Precisa de database?

**Não.** O site é 100% estático. Imagens, vídeos e PDFs são apenas arquivos na pasta; não há cadastro, login nem backend.

---

## 1. Subir no Git

Na pasta **Empreendimento Jardini** (a que contém `jardine/` e as pastas 1 a 7):

```bash
cd "/Users/douglasrinckus/Downloads/Empreendimento Jardini"
git init
git add .
git commit -m "Site Jardine Residence — apresentação estática"
```

Depois crie um repositório no **GitHub** (ou GitLab): New repository → nome, por exemplo `jardine-residence`. Em seguida:

```bash
git remote add origin https://github.com/SEU_USUARIO/jardine-residence.git
git branch -M main
git push -u origin main
```

(Substitua `SEU_USUARIO` pelo seu usuário do GitHub.)

---

## 2. Deploy na Vercel

1. Acesse [vercel.com](https://vercel.com) e faça login (pode ser com conta GitHub).
2. **Add New** → **Project** → importe o repositório `jardine-residence`.
3. **Root Directory**: escolha a pasta que tem **ao mesmo tempo** a pasta `jardine/` e as pastas `1. Apresentação Clientes`, `2. Plantas apartamentos`, etc.  
   - Se o repositório for só o conteúdo de “Empreendimento Jardini”, deixe **Root Directory** em branco.
4. **Build**: em projetos estáticos a Vercel costuma detectar que não há build. Se pedir “Output Directory”, use a pasta que contém o `index.html` (por exemplo `jardine`), e garanta que as pastas 1–7 e a foto da corretora estejam no mesmo nível que `jardine/` (para os `../` funcionarem).
5. **Deploy**. O site ficará em `seu-projeto.vercel.app`.

---

## 3. GitHub Pages (alternativa à Vercel — também grátis)

O **GitHub** permite publicar o site de graça com **GitHub Pages**:

1. Suba o projeto no GitHub (passos da seção 1).
2. No repositório: **Settings** → **Pages** (menu esquerdo).
3. Em **Source** escolha **Deploy from a branch**.
4. Em **Branch** selecione `main` (ou `master`) e a pasta **/ (root)**. Se o seu `index.html` estiver dentro de `jardine/`, use a branch e a pasta **/ (root)** e garanta que a raiz do repo tenha o `index.html` ou configure **Custom source** para a pasta `jardine` (o GitHub Pages pode servir só uma pasta; para manter `jardine/` e as pastas 1–7 no mesmo nível, a estrutura do repo precisa permitir que o Pages sirva a pasta certa — por exemplo, colocar o conteúdo de `jardine` na raiz do repo junto das pastas de mídia).
5. Salve. Em alguns minutos o site estará em `https://SEU_USUARIO.github.io/jardine-residence/`.

**Importante para GitHub Pages:** o site usa `../` para pastas irmãs. O Pages serve apenas uma pasta (a raiz ou uma subpasta). Para funcionar, o repositório precisa ter na **raiz** o `index.html`, `index-es.html`, `estilos.css` e as pastas `1. Apresentação Clientes`, `2. Plantas apartamentos`, etc. (ou seja, mesma estrutura da Opção A do deploy). Se hoje tudo está em `jardine/` com `../` apontando para fora, você pode: (a) mover os HTML/CSS para a raiz e trocar `../` por `./`, ou (b) usar Vercel, que permite configurar a pasta de output.

**Resumo:** sim, o GitHub permite publicar o site; o mais simples é ter os arquivos na raiz do repo (como na Opção A) e ativar Pages na branch `main`.

---

## 4. Domínio próprio (nome que você quiser)

- **Vercel**: você pode **conectar um domínio próprio de graça** (ex.: `jardineresidence.com.br`). Em **Project → Settings → Domains** adicione o domínio; a Vercel mostra o que configurar no seu registrador (DNS).
- **O nome em si** (registro do domínio) costuma ser pago em registradores (Registro.br, GoDaddy, etc.). O **Registro.br** cobra por ano para `.com.br`; às vezes há promoções.
- **Grátis com “nome que você quiser”**: não existe domínio totalmente grátis com qualquer nome (tipo `jardineresidence.com`). O que é grátis:
  - **Subdomínio da Vercel**: `seu-projeto.vercel.app` (já vem).
  - **GitHub Pages**: `usuario.github.io/nome-do-repo` (também grátis).
- **Resumo**: para usar um nome como “jardineresidence”, compre o domínio em um registrador e conecte na Vercel (sem custo extra na Vercel).

---

## 5. Mapa — pin do empreendimento

O iframe da localização usa o link do Google Maps do empreendimento. Se a prévia do mapa não carregar no iframe (alguns navegadores bloqueiam), faça o seguinte:

1. Abra [https://maps.app.goo.gl/PAKAeF87fqE2R4hN6](https://maps.app.goo.gl/PAKAeF87fqE2R4hN6) no Chrome.
2. Clique em **Compartilhar** → **Incorporar um mapa**.
3. Copie o `src` do iframe (começa com `https://www.google.com/maps/embed?pb=...`).
4. No `index.html` e `index-es.html`, na seção Localização, substitua o valor de `src` do `<iframe class="localizacao-mapa">` por esse endereço.
