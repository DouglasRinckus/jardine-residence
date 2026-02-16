#!/usr/bin/env bash
# Otimiza todos os PNG em jardine/img com Oxipng (sem perda de qualidade).
# Reduz tamanho em disco mantendo qualidade idêntica.
#
# Mais rápido: nível 2 (padrão) e vários arquivos em paralelo.
# Para compressão máxima (bem mais lento): OXIPNG_LEVEL=6 ./scripts/otimizar-png-oxipng.sh
#
# Instale o Oxipng antes (Mac):
#   brew install oxipng
#
# Se aparecer "Invalid header / Not a PNG file", os arquivos podem ser
# pointers do Git LFS (não os binários). Baixe os PNG reais com:
#   git lfs pull
#
# Depois rode:
#   ./scripts/otimizar-png-oxipng.sh
set -e
BASE="$(cd "$(dirname "$0")/.." && pwd)"
IMG="$BASE/jardine/img"

# Nível de compressão: 0 (rápido) a 6 (máximo, lento). Padrão 2 = bom e rápido.
OXIPNG_LEVEL="${OXIPNG_LEVEL:-2}"
# Quantos PNGs processar ao mesmo tempo (use o nº de núcleos da CPU se quiser).
OXIPNG_JOBS="${OXIPNG_JOBS:-4}"

if ! command -v oxipng >/dev/null 2>&1; then
  echo "Oxipng não encontrado. Instale com:"
  echo "  brew install oxipng"
  echo ""
  echo "Se o brew der erro de permissão, execute (uma vez):"
  echo "  sudo chown -R \$(whoami) /opt/homebrew"
  exit 1
fi

# Verifica se o arquivo é um pointer do Git LFS (não um PNG real)
is_lfs_pointer() {
  head -c 50 "$1" 2>/dev/null | grep -q '^version https://git-lfs.github.com'
}

# Separa lista de PNGs reais (para otimizar) e conta ignorados
lista_real=$(mktemp)
contagem_ok=$(mktemp)
trap 'rm -f "$lista_real" "$contagem_ok"' EXIT
skip=0
total=0
while IFS= read -r f; do
  ((total++)) || true
  if is_lfs_pointer "$f"; then
    echo "  (ignorado – LFS pointer) ${f#$IMG/}" >&2
    ((skip++)) || true
  else
    echo "$f" >> "$lista_real"
  fi
done < <(find "$IMG" -name "*.png" -type f | sort)

[ "$total" -eq 0 ] && echo "Nenhum PNG em $IMG" && exit 0

num_real=$(wc -l < "$lista_real" | tr -d ' ')
echo "Otimizando PNG em $IMG ($num_real arquivo(s), nível $OXIPNG_LEVEL, $OXIPNG_JOBS em paralelo) ..."
echo ""

processados=0
batch=()
while IFS= read -r f; do
  batch+=("$f")
  if [ "${#batch[@]}" -ge "$OXIPNG_JOBS" ]; then
    for b in "${batch[@]}"; do
      ( oxipng -o "$OXIPNG_LEVEL" "$b" >/dev/null 2>&1 && echo 1 >> "$contagem_ok" ) &
    done
    wait
    ((processados+=${#batch[@]})) || true
    echo "  [ $processados/$num_real ]"
    batch=()
  fi
done < "$lista_real"
# Restante
if [ "${#batch[@]}" -gt 0 ]; then
  for b in "${batch[@]}"; do
    ( oxipng -o "$OXIPNG_LEVEL" "$b" >/dev/null 2>&1 && echo 1 >> "$contagem_ok" ) &
  done
  wait
  ((processados+=${#batch[@]})) || true
  echo "  [ $processados/$num_real ]"
fi

ok=$(wc -l < "$contagem_ok" 2>/dev/null | tr -d ' ')
[ -z "$ok" ] && ok=0

echo ""
echo "Concluído: $ok PNG(s) otimizado(s), $skip ignorado(s)."
if [ "$skip" -gt 0 ]; then
  echo "Se há muitos ignorados, baixe os binários com: git lfs pull"
fi
