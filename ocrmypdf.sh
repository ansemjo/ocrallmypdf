#!/usr/bin/env bash
set -e

# input and output
INFILE=${1:?input file required}
OUTDIR=${2:?output directory required}
OUTFILE="${OUTDIR}/$(basename "${INFILE}")"

# ocrmypdf location
OCRMYPDF=${OCRMYPDF:-/appenv/bin/ocrmypdf}

# ocrmypdf options
OPTIONS=${OCR_OPTIONS:---clean --deskew --output-type pdfa --skip-text}
LANGUAGE=${OCR_LANGUAGE:-deu+eng}

# run ocr processing
echo "PROCESSING $(basename "${INFILE}")"
${OCRMYPDF} ${OPTIONS} --language ${LANGUAGE} "${INFILE}" "${OUTFILE}"

# fix permissions if root
if [[ ${EUID} -eq 0 ]]; then
  chmod --reference "${INFILE}" "${OUTFILE}"
  chown --reference "${INFILE}" "${OUTFILE}"
fi

# remove original file
if [[ ${REMOVE_ORIGINAL} =~ true|y(es)|on ]]; then
  rm -f "${INFILE}"
fi
