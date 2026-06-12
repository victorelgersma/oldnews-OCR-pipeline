#!/opt/homebrew/bin/bash 

# Bash 5 only

# Ensure the required environment variable is set
if [ -z "$OLDNEWS_OCR_FOLDER" ]; then
    echo "Error: Environment variable \$OLDNEWS_OCR_FOLDER is not set."
    exit 1
fi

if [ ! -d "$OLDNEWS_OCR_FOLDER" ]; then
    echo "Error: Directory '$OLDNEWS_OCR_FOLDER' not found."
    exit 1
fi

# Create a secure temporary file to consolidate the OCR results
temp_ocr_out=$(mktemp /tmp/oldnews_ocr.XXXXXX)

# Enable nullglob so the loop doesn't fail if an extension is missing
# Enable nocaseglob so it catches .PNG, .png, .JPEG, .jpg, etc.
shopt -s nullglob nocaseglob

echo "Beginning OCR processing from: $OLDNEWS_OCR_FOLDER"
echo "Results will be stored in temporary file: $temp_ocr_out"

# Loop through both png and jpeg variations
for input_file in "$OLDNEWS_OCR_FOLDER"/*.{png,jpeg,jpg}; do
    filename=$(basename "$input_file")
    echo "Processing image: $filename"
    
    # Run Tesseract streaming directly to standard output, then append to our temp file
    # stdout is specified by using '-' or 'stdout' depending on tesseract version wrappers
    tesseract --oem 1 --psm 4 "$input_file" stdout >> "$temp_ocr_out" 2>/dev/null
    
    # Add a newline spacer between processed images
    echo -e "\n" >> "$temp_ocr_out"
done

echo "OCR Complete. Consolidated text written to: $temp_ocr_out"