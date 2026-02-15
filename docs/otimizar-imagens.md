# Reduzir tamanho das imagens sem perder qualidade

As imagens da apresentação e das plantas (PNG em 300 DPI) podem ficar pesadas. Abaixo, opções que **reduzem o tamanho mantendo qualidade visual** (ou muito próxima).

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
