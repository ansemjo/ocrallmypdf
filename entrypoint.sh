#!/usr/bin/env bash

# Copyright (c) 2019 Anton Semjonov
# Licensed under the MIT License

# install additional languages
IFS=+ read -ra languages <<< "${OCR_LANGUAGE}"
for pkg in "${languages[@]/#/tesseract-ocr-}"; do
  dpkg -s "${pkg}" >/dev/null && continue
  [[ $updated != "yes" ]] && { apt-get update && updated=yes; }
  apt-get install -y "${pkg}"
done

# set number of concurrent jobs in spooler
tsp -S ${JOBS:-1}

# input and output directories
INPUT=${INPUT:-/input}
OUTPUT=${OUTPUT:-/output}

# insert incron watcher
printf '%q IN_CLOSE_WRITE,IN_MOVED_TO tsp -nf /ocrmypdf.sh $@/$# %q\n' "$INPUT" "$OUTPUT" | incrontab - >/dev/null
sleep 1

# start incrond
incrond --kill 2>/dev/null || true
exec incrond --foreground
