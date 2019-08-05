# ocrallmypdf

This is a minimal wrapper around the `jbarlow83/ocrmypdf` container which
adds an inotify-based directory watcher and automatically runs OCR processing
on all incoming files in the input directory.

Think of this as a simplified version of [cmccambridge/ocrmypdf-auto](https://github.com/cmccambridge/ocrmypdf-auto),
where `ocrallmypdf` is using the existing tools `incron` and `task-spooler`
to achieve a similar effect.

## USAGE

Use your container runtime of choice and run:

    docker run -d \
      -v /path/to/input:/input \
      -v /path/to/output:/output \
      ansemjo/ocrallmypdf

Existing files in the input directory are not processed. The processing only
triggers on `CLOSE_WRITE` and `MOVED_TO` events.

The container can be customized with a number of environment variables:

| env | description | default |
| --- | ----------- | ------- |
| `INPUT` | watched input directory inside of the container | `/input` |
| `OUTPUT` | output directory for processed file in the container, *be careful not to create an inotify loop by using the same directories!* | `/output` |
| `OCR_OPTIONS` | options passed to `ocrmypdf` command | `--clean --deskew --output-type pdfa --skip-text` |
| `OCR_LANGUAGE` | language used with tesseract (`-l` flag of `ocrmypdf`), missing languages will be installed on startup | `deu+eng` |
| `REMOVE_ORIGINAL` | truthy value whether to remove original input files | `yes` |
| `JOBS` | number of concurrent jobs in task spooler, *using too many at once may lead to ocr timeouts, since `ocrmypdf` uses all cores per process by default* | `1` |
