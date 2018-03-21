#!/usr/bin/env bash
SATIS_PATH=${SATIS_PATH:-"/satisfy/vendor"}
SATIS_BIN=${SATIS_BIN:-"/satisfy/bin/satis"}
SATIS_PUBLIC=${SATIS_PUBLIC:-"/satisfy/web/"}

${SATIS_BIN} -v -n build /app/config.json ${SATIS_PUBLIC}
