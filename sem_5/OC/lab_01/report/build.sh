#!/bin/bash
# Сборка отчёта: листинги из TEMP.LST -> обрезка схем -> PDF.
# Использование:  ./build.sh        собрать
#                 ./build.sh clean  удалить всё сгенерированное

set -euo pipefail
cd "$(dirname "$0")"

export PATH="/Library/TeX/texbin:/opt/homebrew/bin:$PATH"

if [ "${1:-}" = "clean" ]; then
    latexmk -C
    rm -f algo-crop.pdf .algo-tmp.pdf listing-int08.lst listing-sub1.lst
    echo "Очищено."
    exit 0
fi

for cmd in python3 pdfcrop pdftocairo latexmk; do
    command -v "$cmd" >/dev/null || {
        echo "Нет команды '$cmd'." >&2
        [ "$cmd" = python3 ] || echo "Проверь PATH к TeX: eval \"\$(/usr/libexec/path_helper)\"" >&2
        exit 1
    }
done

[ -f ../artefacts/TEMP.LST ] || { echo "Нет ../artefacts/TEMP.LST" >&2; exit 1; }
[ -f algo.pdf ]              || { echo "Нет algo.pdf — выгрузи схемы из draw.io" >&2; exit 1; }

echo "==> Листинги из TEMP.LST"
python3 mklisting.py

# Кропаем, только если algo.pdf новее результата
if [ ! -f algo-crop.pdf ] || [ algo.pdf -nt algo-crop.pdf ]; then
    echo "==> Обрезка полей схем"
    pdfcrop --margins 8 algo.pdf .algo-tmp.pdf >/dev/null
    # draw.io зашивает XML диаграммы в метаданные, xdvipdfmx на них ругается;
    # pdftocairo переписывает файл начисто, содержимое не меняя
    pdftocairo -pdf .algo-tmp.pdf algo-crop.pdf
    rm -f .algo-tmp.pdf
else
    echo "==> Схемы не менялись, обрезка пропущена"
fi

echo "==> XeLaTeX"
latexmk -xelatex -interaction=nonstopmode -halt-on-error report.tex >/dev/null

echo
echo "Готово: $(pwd)/report.pdf"
command -v pdfinfo >/dev/null && pdfinfo report.pdf | grep -E '^Pages'
