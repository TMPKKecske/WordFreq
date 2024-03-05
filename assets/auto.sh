#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <input_filename>"
    exit 1
fi

# Assign input filename to a variable
input_file=$1

# Check if the input file exists
if [ ! -f "$input_file" ]; then
    echo "File $input_file not found!"
    exit 1
fi

# Apply sed commands
sed '0~6!d' "$input_file" > temp_file1
sed -n 's/.*title="\([^"]*\)".*/\1/p' temp_file1 > temp_file2
sed -i 's/(page does not exist)//g' temp_file2

# Clean up temporary files
rm temp_file1

echo "Processing complete. Output is stored in 'temp_file2'."

