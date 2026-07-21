#!/opt/homebrew/bin/bash 

# Verify tesseract is actually installed before doing anything else
if ! command -v tesseract &> /dev/null; then
    echo "Error: 'tesseract' is not installed or not in your PATH."
    echo "Run: brew install tesseract"
    exit 1
fi

# Ensure the required folder variable is set
OLDNEWS_OCR_FOLDER=~/Desktop/museum-nuisance/

if [ -z "$OLDNEWS_OCR_FOLDER" ]; then
    echo "Error: Environment variable \$OLDNEWS_OCR_FOLDER is not set."
    exit 1
fi

if [ ! -d "$OLDNEWS_OCR_FOLDER" ]; then
    echo "Error: Directory '$OLDNEWS_OCR_FOLDER' not found."
    exit 1
fi

# Create a secure temporary file
temp_ocr_out=$(mktemp /tmp/oldnews_ocr.XXXXXX)

# Enable nullglob and nocaseglob safely
shopt -s nullglob nocaseglob

echo "Beginning OCR processing from: $OLDNEWS_OCR_FOLDER"
echo "Results will be stored in temporary file: $temp_ocr_out"

# Change directory into the folder temporarily so globbing is perfectly clean
cd "$OLDNEWS_OCR_FOLDER" || exit 1

# Loop through files safely by matching individual patterns explicitly
for input_file in *.png *.jpeg *.jpg; do
    # Verify it's actually a file just in case
    [ -f "$input_file" ] || continue
    
    echo "Processing image: $input_file"
    
    # Using '-' forces Tesseract to send plain text straight to standard output
    tesseract --oem 1 --psm 4 "$input_file" - >> "$temp_ocr_out" 2>/dev/null
    
    # Add a clean newline spacer
    echo -e "\n" >> "$temp_ocr_out"
done

echo "OCR Complete. Consolidated text written to: $temp_ocr_out"