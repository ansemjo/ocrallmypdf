# Copyright (c) 2019 Anton Semjonov
# Licensed under the MIT License

FROM jbarlow83/ocrmypdf

# install additional requirements
RUN apt-get update \
  && apt-get install -y incron task-spooler \
  && rm -rf /var/lib/apt/lists/*

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
