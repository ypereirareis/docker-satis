#!/usr/bin/env bash
SATIS_PATH="/satisfy/vendor"
SATIS_BIN="/satisfy/bin/satis"
SATIS_PUBLIC="/satisfy/web/"

${SATIS_BIN} -n build /app/config.json ${SATIS_PUBLIC}
