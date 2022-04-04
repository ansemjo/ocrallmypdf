# Copyright (c) 2019 Anton Semjonov
# Licensed under the MIT License

FROM jbarlow83/ocrmypdf

# install additional requirements
# TODO: temporarily install incron from url
# TODO: it's not available in debian/bookworm
# TODO: since ocrmypdf/OCRmyPDF 79382a6
RUN apt-get update \
  && apt-get install -y wget task-spooler \
  && export deb=incron_0.5.12-2_amd64.deb \
  && wget "http://ftp.debian.org/debian/pool/main/i/incron/$deb" \
  && echo "eb94045f280c260a4b44ab28ccd9d63ecb40401cfdb3cd5c8cf4c45276d00837  $deb" | sha256sum -c \
  && dpkg -i "$deb" \
  && rm -rf /var/lib/apt/lists/* "$deb"

# allow root to use incron
RUN echo root >> /etc/incron.allow

# set env defaults
ENV \
  OCRMYPDF="/appenv/bin/ocrmypdf" \
  OCR_OPTIONS="--clean --deskew --output-type pdfa --skip-text" \
  OCR_LANGUAGE="deu+eng" \
  REMOVE_ORIGINAL="yes" \
  JOBS="1" \
  INPUT="/input" \
  OUTPUT="/output"

# copy scripts
COPY entrypoint.sh /entrypoint.sh
COPY ocrmypdf.sh /ocrmypdf.sh
RUN chmod +x /entrypoint.sh /ocrmypdf.sh

# execute entrypoint which starts incrond
ENTRYPOINT ["/entrypoint.sh"]
