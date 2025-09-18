#!/bin/bash

# Wayback Deep URL Extractor - Save all URLs to single file

print_usage() {
    echo "Usage:"
    echo "  $0 target.com              # For single target"
    echo "  $0 -f targets.txt          # For multiple targets from file"
    echo "  Optional: -o output.txt    # Custom output file (default: all_wayback_urls.txt)"
    exit 1
}

OUTPUT_FILE="all_wayback_urls.txt"
TARGETS=()

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -f)
            INPUT_FILE="$2"
            shift 2
            ;;
        -o)
            OUTPUT_FILE="$2"
            shift 2
            ;;
        -*)
            echo "Unknown option: $1"
            print_usage
            ;;
        *)
            TARGETS+=("$1")
            shift
            ;;
    esac
done

# Validate input
if [[ -n "$INPUT_FILE" ]]; then
    if [[ ! -f "$INPUT_FILE" ]]; then
        echo "[-] File not found: $INPUT_FILE"
        exit 1
    fi
    while read -r line; do
        [[ -z "$line" || "$line" =~ ^# ]] && continue
        TARGETS+=("$line")
    done < "$INPUT_FILE"
fi

if [[ ${#TARGETS[@]} -eq 0 ]]; then
    print_usage
fi

echo "[*] Starting deep URL extraction..."
> "$OUTPUT_FILE"

for TARGET in "${TARGETS[@]}"; do
    echo "[*] Fetching URLs for: $TARGET"
    ARCHIVE_URL="http://web.archive.org/cdx/search/cdx?url=$TARGET/*&output=text&fl=original&collapse=urlkey"

    # Deep mode - No collapse
    # To get even more detailed results, remove collapse
    # ARCHIVE_URL="http://web.archive.org/cdx/search/cdx?url=$TARGET/*&output=text&fl=original"

    # You can also include statuscode or timestamp if needed for filtering

    curl -s "$ARCHIVE_URL" >> "$OUTPUT_FILE"
done

# Sort and clean duplicates
sort -u "$OUTPUT_FILE" -o "$OUTPUT_FILE"

echo "[+] Done! All URLs saved to: $OUTPUT_FILE"
