SATIS_PATH="/satis"
SATIS_BIN="${SATIS_PATH}/bin/satis"
SATIS_PUBLIC="${SATIS_PATH}/web/"

${SATIS_BIN} -n build /app/config.json ${SATIS_PUBLIC}
