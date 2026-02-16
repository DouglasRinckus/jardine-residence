#!/usr/bin/env bash
# Redimensiona PNGs em jardine/img para ficarem no máximo TARGET_MB (ex.: 5 ou 10).
# Arquivos já menores que o limite não são alterados.
# Usa sips (nativo do macOS). Reduz resolução, depois otimiza com oxipng se disponível.
#
# Uso:
#   ./scripts/redimensionar-png-max-mb.sh           # limite 10 MB (padrão)
#   TARGET_MB=5 ./scripts/redimensionar-png-max-mb.sh   # limite 5 MB
#
# Se os PNGs forem pointers do Git LFS, baixe antes: git lfs pull
set -e
BASE="$(cd "$(dirname "$0")/.." && pwd)"
IMG="$BASE/jardine/img"
TARGET_MB="${TARGET_MB:-10}"
TARGET_BYTES=$((TARGET_MB * 1024 * 1024))

is_lfs_pointer() {
  head -c 50 "$1" 2>/dev/null | grep -q '^version https://git-lfs.github.com'
}

get_size() { stat -f%z "$1" 2>/dev/null || stat -c%s "$1" 2>/dev/null; }
get_width() { sips -g pixelWidth "$1" 2>/dev/null | awk '/pixelWidth/{print $2}'; }
get_height() { sips -g pixelHeight "$1" 2>/dev/null | awk '/pixelHeight/{print $2}'; }

total=0
redim=0
ignorados=0
while IFS= read -r f; do
  ((total++)) || true
  rel="${f#$IMG/}"
  if is_lfs_pointer "$f"; then
    echo "  (ignorado – LFS pointer) $rel"
    ((ignorados++)) || true
    continue
  fi
  sz=$(get_size "$f")
  if [ -z "$sz" ] || [ "$sz" -le "$TARGET_BYTES" ]; then
    echo "  (ok – já ≤ ${TARGET_MB} MB) $rel"
    continue
  fi
  w=$(get_width "$f")
  h=$(get_height "$f")
  if [ -z "$w" ] || [ -z "$h" ] || [ "$w" -le 0 ] || [ "$h" -le 0 ]; then
    echo "  (ignorado – não foi possível ler dimensões) $rel"
    ((ignorados++)) || true
    continue
  fi
  # scale = sqrt(target/current) * 0.85 para ficar um pouco abaixo do limite
  scale=$(awk -v t="$TARGET_BYTES" -v s="$sz" 'BEGIN {printf "%.4f", sqrt(t/s)*0.85}' 2>/dev/null) || scale="0.5"
  new_w=$(awk -v w="$w" -v sc="$scale" 'BEGIN {n=int(w*sc); if(n<100)n=100; print n}' 2>/dev/null) || new_w=$((w * 85 / 100))
  new_h=$(awk -v h="$h" -v sc="$scale" 'BEGIN {n=int(h*sc); if(n<100)n=100; print n}' 2>/dev/null) || new_h=$((h * 85 / 100))
  [ "${new_w:-0}" -lt 100 ] && new_w=100
  [ "${new_h:-0}" -lt 100 ] && new_h=100
  sips -z "$new_h" "$new_w" "$f" >/dev/null 2>&1
  new_sz=$(get_size "$f")
  mib_new=$(awk -v s="$new_sz" 'BEGIN {printf "%.2f", s/1024/1024}' 2>/dev/null) || mib_new="?"
  mib_old=$(awk -v s="$sz" 'BEGIN {printf "%.2f", s/1024/1024}' 2>/dev/null) || mib_old="?"
  echo "  [redimensionado] $rel  →  ${mib_new} MiB (era ${mib_old} MiB)"
  ((redim++)) || true
done < <(find "$IMG" -name "*.png" -type f | sort)

total_arq=$(find "$IMG" -name "*.png" -type f | wc -l | tr -d ' ')
echo ""
echo "Arquivos processados no total: $total_arq"
echo "Concluído: $redim redimensionado(s), $((total_arq - redim - ignorados)) já ≤ ${TARGET_MB} MB, $ignorados ignorado(s)."
if command -v oxipng >/dev/null 2>&1 && [ "$redim" -gt 0 ]; then
  echo "Rode ./scripts/otimizar-png-oxipng.sh para reotimizar os PNGs após o redimensionamento."
fi
