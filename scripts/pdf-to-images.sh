#!/usr/bin/env bash
# Converte cada página dos PDFs do site em PNG e gera manifest para o lightbox.
# Qualidade: DPI (padrão 300). Para mais nitidez: PDF_DPI=400 ./scripts/pdf-to-images.sh
# Requer: pdftoppm (brew install poppler)
set -e
BASE="$(cd "$(dirname "$0")/.." && pwd)"
SITE="$BASE/site"
IMG="$SITE/img"
R="${PDF_DPI:-300}"
echo "Convertendo com ${R} DPI..."

mkdir -p "$IMG/apresentacao"
mkdir -p "$IMG/plantas-apartamentos/localizacao"
mkdir -p "$IMG/plantas-apartamentos/tipo-01"
mkdir -p "$IMG/plantas-apartamentos/tipo-02"
mkdir -p "$IMG/plantas-apartamentos/tipo-03"
mkdir -p "$IMG/plantas-apartamentos/tipo-04"
mkdir -p "$IMG/plantas-apartamentos/tipo-05"
mkdir -p "$IMG/plantas-apartamentos/tipo-06"
mkdir -p "$IMG/plantas-lazer/g5"
mkdir -p "$IMG/plantas-lazer/rft"

pdf_to_pngs() {
  local pdf="$1"
  local outdir="$2"
  local prefix="$3"
  if [[ ! -f "$pdf" ]]; then
    echo "AVISO: PDF não encontrado: $pdf"
    return 1
  fi
  cd "$outdir"
  pdftoppm -png -r "$R" "$pdf" "$prefix" 2>/dev/null || true
  # Renomear em ordem numérica (p-1, p-2, ..., p-10) -> 01.png, 02.png, ...
  # O glob p-*.png viria em ordem lexicográfica (p-1, p-10, p-11, p-2...); por isso iteramos pelo número.
  local n=0
  local i=1
  while [[ -f "$prefix-$i.png" ]]; do
    mv "$prefix-$i.png" "$(printf "%02d.png" "$i")"
    n=$i
    (( i++ )) || true
  done
  cd - >/dev/null
  echo "$n"
}

# Apresentação (várias páginas)
PDF_APRES="$BASE/1. Apresentação Clientes/Capitali - Jardine Residence - 05 - Clientes (1).pdf"
count_apres=0
if [[ -f "$PDF_APRES" ]]; then
  count_apres=$(pdf_to_pngs "$PDF_APRES" "$IMG/apresentacao" "p")
  echo "Apresentação: $count_apres páginas"
fi

# Plantas apartamentos (cada um pode ter 1 ou mais páginas)
pdf_to_pngs "$BASE/2. Plantas apartamentos/LOCALIZAÇÃO PLANTA.pdf" "$IMG/plantas-apartamentos/localizacao" "p"
pdf_to_pngs "$BASE/2. Plantas apartamentos/Tipo 01_MKT_R00.pdf" "$IMG/plantas-apartamentos/tipo-01" "p"
pdf_to_pngs "$BASE/2. Plantas apartamentos/Tipo 02_MKT_R00.pdf" "$IMG/plantas-apartamentos/tipo-02" "p"
pdf_to_pngs "$BASE/2. Plantas apartamentos/Tipo 03_MKT_R00.pdf" "$IMG/plantas-apartamentos/tipo-03" "p"
pdf_to_pngs "$BASE/2. Plantas apartamentos/Tipo 04_MKT_R00.pdf" "$IMG/plantas-apartamentos/tipo-04" "p"
pdf_to_pngs "$BASE/2. Plantas apartamentos/Tipo 05_MKT_R00.pdf" "$IMG/plantas-apartamentos/tipo-05" "p"
pdf_to_pngs "$BASE/2. Plantas apartamentos/Tipo 06_MKT_R00.pdf" "$IMG/plantas-apartamentos/tipo-06" "p"
pdf_to_pngs "$BASE/3. Plantas lazer/JD_ARQ EXE_AP_Planta Baixa_G5_R31.pdf" "$IMG/plantas-lazer/g5" "p"
pdf_to_pngs "$BASE/3. Plantas lazer/JD_ARQ EXE_AP_Planta Baixa_RFT_R32.pdf" "$IMG/plantas-lazer/rft" "p"

# Gerar manifest.json via Node (JSON válido)
if command -v node >/dev/null 2>&1; then
  node "$BASE/scripts/build-img-manifest.js" && echo "Manifest escrito em $IMG/manifest.json"
else
  echo "AVISO: node não encontrado; rode scripts/build-img-manifest.js manualmente após a conversão."
fi
echo "Concluído."
