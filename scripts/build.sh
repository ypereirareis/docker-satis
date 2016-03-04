SATIS_PATH="/satisfy/vendor"
SATIS_BIN="/satisfy/vendor/bin/satis"
SATIS_PUBLIC="/satisfy/web/"

${SATIS_BIN} -n build /app/config.json ${SATIS_PUBLIC}

# bypass nginx statig file cache problems..
cat "${SATIS_PUBLIC}packages.json" > "${SATIS_PUBLIC}packages.json.tmp";
mv "${SATIS_PUBLIC}packages.json.tmp" "${SATIS_PUBLIC}packages.json";
