# Reduzir tamanho das imagens sem perder qualidade

As imagens da apresentação e das plantas (PNG em 300 DPI) podem ficar pesadas. Abaixo, o **fluxo que usamos com os scripts do projeto** e outras opções.

---

## Como reduzir as imagens (fluxo que usamos)

Este é o processo que usamos para deixar os PNGs menores: **redimensionar** (limite em MB) e depois **otimizar** com Oxipng. Os scripts estão em `scripts/`.

### Pré-requisitos

- **macOS** (os scripts usam `sips` e `stat -f%z`).
- **Oxipng** (para otimizar): `brew install oxipng`
- Se os PNGs estiverem em **Git LFS** e no disco estiverem só os “pointers”, baixe os arquivos reais antes:
  ```bash
  git lfs pull
  ```

### Passo 1: Redimensionar (limite por arquivo, ex.: 10 MB ou 5 MB)

Reduz a **resolução** dos PNGs que passam do limite (menos pixels = arquivo menor). Quem já está abaixo do limite não é alterado.

```bash
# Limite de 10 MB (padrão) — recomendado
./scripts/redimensionar-png-max-mb.sh

# Limite de 5 MB (arquivos ainda menores)
TARGET_MB=5 ./scripts/redimensionar-png-max-mb.sh
```

- O script mostra **quantos arquivos foram processados** e quantos foram redimensionados.
- No final sugere rodar o script de otimização (Oxipng).

### Passo 2: Otimizar PNG (compressão sem perda)

Depois de redimensionar (ou sempre que quiser só “apertar” o PNG sem mudar pixels):

```bash
./scripts/otimizar-png-oxipng.sh
```

- Usa **nível 2** e **4 arquivos em paralelo** (rápido).
- Para compressão máxima (mais lento): `OXIPNG_LEVEL=6 ./scripts/otimizar-png-oxipng.sh`
- Mostra progresso `[ n/total ]` e no final: quantos otimizados e quantos ignorados (ex.: LFS pointer).

### Passo 3: Subir as alterações

```bash
git add site/img/
git add scripts/redimensionar-png-max-mb.sh   # se tiver alterado/adicionado
git commit -m "Redimensionar/otimizar PNGs (máx. 10 MB)"
git push origin main
```

Se usar LFS, o `git push` envia os novos binários para o LFS.

### Resumo do fluxo

1. `git lfs pull` (se precisar dos PNGs reais)
2. `./scripts/redimensionar-png-max-mb.sh` (ou com `TARGET_MB=5` se quiser menor)
3. `./scripts/otimizar-png-oxipng.sh`
4. `git add` → `git commit` → `git push`

Assim você pode repetir o processo no futuro sempre que quiser reduzir de novo as imagens.

### Scripts e opções (referência)

| Script | Função | Variáveis de ambiente |
|--------|--------|------------------------|
| `scripts/redimensionar-png-max-mb.sh` | Reduz resolução até cada PNG ficar ≤ N MB | `TARGET_MB=10` (ou 5, etc.) |
| `scripts/otimizar-png-oxipng.sh` | Comprime PNG sem perda (Oxipng) | `OXIPNG_LEVEL=2`, `OXIPNG_JOBS=4` |

---

## 1. Serviços online (recomendado)

### TinyPNG
- **Site:** [https://tinypng.com](https://tinypng.com)
- Arraste a pasta `site/img` (ou os PNGs) e faça o upload; baixe os arquivos otimizados e substitua os atuais.
- Usa compressão “inteligente”: reduz bastante o tamanho com perda visual mínima (quase imperceptível).

### Squoosh (Google)
- **Site:** [https://squoosh.app](https://squoosh.app)
- Abra cada PNG (ou em lote), escolha **Oxipng** (PNG sem perda) ou **WebP** em modo “Lossless” e exporte.
- Permite comparar antes/depois e ajustar qualidade.

### Resumo
- **TinyPNG:** mais rápido, arrastar e baixar.
- **Squoosh:** mais controle (WebP lossless, PNG otimizado, comparação visual).

Depois de gerar os arquivos, substitua o conteúdo de `site/img/` pelos otimizados, rode `node scripts/build-img-manifest.js` e faça commit + push (e LFS, se usar).

---

## 2. WebP em modo lossless (local)

O formato **WebP** pode ser **lossless** (sem perda): mesma qualidade do PNG, arquivos menores.

### Usando cwebp (linha de comando)

1. Instale o pacote (no Mac com Homebrew):
   ```bash
   brew install webp
   ```

2. Converta todos os PNG da apresentação para WebP lossless:
   ```bash
   cd "Empreendimento Jardini/site/img/apresentacao"
   for f in *.png; do cwebp -lossless -q 100 "$f" -o "${f%.png}.webp"; done
   ```

3. Repita para as pastas em `plantas-apartamentos/` e `plantas-lazer/`.

Para o **site** usar WebP, seria preciso:
- Gerar um manifest com `.webp` (ou um manifest que liste ambos) e
- No JavaScript, usar `.webp` quando o navegador suportar e fallback para `.png` caso contrário.

Se quiser seguir esse caminho, podemos adaptar o `manifest` e o código do lightbox para WebP + fallback.

---

## 3. PNG otimizado (local, sem perda)

Ferramentas que só removem dados desnecessários do PNG (sem mudar pixels):

- **Oxipng** (Rust): `brew install oxipng` e depois `oxipng -o 6 site/img/**/*.png`
- **OptiPNG**: `brew install optipng` e depois `optipng -o6 site/img/**/*.png`

O arquivo continua PNG; só o tamanho em disco diminui, sem perda de qualidade.

---

## Resumo prático

| Opção              | Onde fazer | Qualidade      | Esforço   |
|--------------------|------------|----------------|-----------|
| TinyPNG            | Internet   | Quase igual    | Mínimo    |
| Squoosh            | Internet   | Igual (lossless) ou quase | Médio |
| WebP lossless      | Local (cwebp) | Igual       | Médio*    |
| Oxipng / OptiPNG   | Local      | Igual          | Baixo     |

\* WebP exige alterar o site para servir `.webp` (e fallback `.png`).

Para **reduzir tamanho sem se preocupar com perda visível**, o caminho mais simples é **TinyPNG** ou **Squoosh** na internet.
