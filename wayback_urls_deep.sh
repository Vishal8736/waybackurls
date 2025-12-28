#!/bin/bash

# Wayback Deep URL Extractor - Advanced Version
# Author: Gemini AI Thought Partner (Modified for Performance)

# Colors for better visibility
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_usage() {
    echo -e "${BLUE}Usage:${NC}"
    echo "  $0 target.com              # Single target"
    echo "  $0 -f targets.txt          # Multiple targets from file"
    echo "  -o output.txt              # Custom output file"
    echo "  --deep                     # Fetch all history (No collapse)"
    echo "  --filter                   # Remove junk (images, css, fonts)"
    exit 1
}

# Default Settings
OUTPUT_FILE="all_wayback_urls.txt"
TARGETS=()
DEEP_MODE=false
FILTER_JUNK=false

# Argument Parsing
while [[ $# -gt 0 ]]; do
    case "$1" in
        -f) INPUT_FILE="$2"; shift 2 ;;
        -o) OUTPUT_FILE="$2"; shift 2 ;;
        --deep) DEEP_MODE=true; shift ;;
        --filter) FILTER_JUNK=true; shift ;;
        -*) echo -e "${RED}[!] Unknown option: $1${NC}"; print_usage ;;
        *) TARGETS+=("$1"); shift ;;
    esac
done

# File loading logic
if [[ -n "$INPUT_FILE" ]]; then
    if [[ ! -f "$INPUT_FILE" ]]; then
        echo -e "${RED}[-] File not found: $INPUT_FILE${NC}"
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

echo -e "${GREEN}[*] Starting Deep URL Extraction...${NC}"
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

# Function to fetch URLs
fetch_urls() {
    local target=$1
    local output_part="$TEMP_DIR/$target.txt"
    
    local COLLAPSE="&collapse=urlkey"
    [[ "$DEEP_MODE" == true ]] && COLLAPSE=""

    local ARCHIVE_URL="http://web.archive.org/cdx/search/cdx?url=$target/*&output=text&fl=original$COLLAPSE"
    
    echo -e "${YELLOW}[+] Fetching:${NC} $target"
    curl -s -L "$ARCHIVE_URL" > "$output_part"
}

export -f fetch_urls
export TEMP_DIR DEEP_MODE YELLOW NC

# Run fetching in Parallel (Max 5 targets at a time)
printf "%s\n" "${TARGETS[@]}" | xargs -I{} -P 5 bash -c 'fetch_urls "{}"'

# Combine all results
cat "$TEMP_DIR"/*.txt > "$OUTPUT_FILE"

# Filtering Noise (CSS, Images, Fonts)
if [[ "$FILTER_JUNK" == true ]]; then
    echo -e "${BLUE}[*] Filtering junk files...${NC}"
    grep -ivE "\.(jpg|jpeg|png|gif|css|woff|woff2|ttf|svg|pdf|eot|ico|otf)$" "$OUTPUT_FILE" > "$OUTPUT_FILE.tmp"
    mv "$OUTPUT_FILE.tmp" "$OUTPUT_FILE"
fi

# Final Cleanup (Sort and Unique)
sort -u "$OUTPUT_FILE" -o "$OUTPUT_FILE"

# Statistics & Summary
TOTAL_URLS=$(wc -l < "$OUTPUT_FILE")
echo -e "\n${GREEN}-----------------------------------------${NC}"
echo -e "${GREEN}[+] Extraction Complete!${NC}"
echo -e "${BLUE}[>] Total Unique URLs Saved:${NC} $TOTAL_URLS"
echo -e "${BLUE}[>] Output Location:${NC} $OUTPUT_FILE"

# Highlighting Sensitive Files (Bonus Feature)
SENSITIVE=$(grep -iE "\.(sql|env|conf|bak|ini|log|zip|tar|gz)$" "$OUTPUT_FILE" | wc -l)
if [[ $SENSITIVE -gt 0 ]]; then
    echo -e "${RED}[!] Critical: Found $SENSITIVE potentially sensitive files! Check them in the output.${NC}"
fi
echo -e "${GREEN}-----------------------------------------${NC}"
