#!/bin/bash

input=$1
output=$2

#проверяем, что заданы обе директории
if [[ "$#" -ne 2 ]]; then
    echo "Enter two directories"
    exit 1
fi

#проверяем, что оба аргумента являются директориями
if [ ! -d "$input" ] || [ ! -d "$output" ]; then
    echo "Arguments should be directories"
    exit 1
fi

#получаем список файлов только входной директории
files=$(find "$1" -maxdepth 1 -type f)
echo "Files in input directory:"
echo "$files"

#получаем список всех директорий во входной директории
directories=$(find "$1" -mindepth 1 -type d)
echo "Directories in input directory:"
echo "$directories"

#получаем список всех файлов, вложенных во входную директорию
all_files=$(find $input -type f)
echo "All files in directory:"
echo "$all_files"

#функция копирования файлов
copy() {
  local from=$1
      local to=$2
    for file in "$1"/*; do
        if [[ -d "$file" ]]; then
            copy "$file" "$to"
        elif [[ -f "$file" ]]; then
            name=$(basename "$file")
            res="$to/$name"
            #проверяем имя файла на повторение
            if [[ -e "$res" ]]; then
                i=1
                while [[ -e "$to/$i$name" ]]; do
                    ((i++))
                done
                res="$to/$i$name"
            fi
            cp "$file" "$res" 
        fi
    done
}

copy "$input" "$output"

echo "Files copied"