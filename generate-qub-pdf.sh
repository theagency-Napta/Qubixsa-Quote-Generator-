#!/bin/bash
# Generate PDF from exported HTML using Google Chrome
set -euo pipefail

HTML="${1:-}"
if [[ -z "$HTML" || ! -f "$HTML" ]]; then
  echo "Usage: bash generate-qub-pdf.sh /path/to/quote.html" >&2
  exit 1
fi

PDF="${HTML%.html}.pdf"
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

if [[ ! -x "$CHROME" ]]; then
  echo "Google Chrome not found. Print from the browser instead (see PRINT-CHECKLIST.md)." >&2
  exit 1
fi

for MODE in new old; do
  if "$CHROME" --headless="$MODE" --disable-gpu --no-sandbox --no-first-run \
    --no-pdf-header-footer --virtual-time-budget=5000 \
    --print-to-pdf="$PDF" "file://${HTML}" 2>/dev/null; then
    echo "PDF created: $PDF"
    open "$PDF" 2>/dev/null || true
    exit 0
  fi
done

echo "Chrome headless failed. Open the HTML and use Print → Save as PDF." >&2
exit 1
