#!/usr/bin/env bash

IMAGE_NAME="ypereirareis/docker-satis"
VERSION="4.2"
CONTAINER_NAME="satis-test"
EXIT_CODE=0

function check_errors() {
  [ "$1" == "0" ] || EXIT_CODE=$?
}

function build() {
  docker build -t "${IMAGE_NAME}:${VERSION}" .
  check_errors $?
}

function run() {
  docker rm -f "${CONTAINER_NAME}" || true

  docker run -itd --name "${CONTAINER_NAME}" "${IMAGE_NAME}:${VERSION}"
  check_errors $?

  docker exec -it "${CONTAINER_NAME}" bash -c "cat /app/config.json && ./scripts/build.sh"
  check_errors $?

  docker rm -f "${CONTAINER_NAME}"
  check_errors $?
}

function test_all() {
  echo "=== START"
  build
  run
  echo "=== END"
}

test_all
exit ${EXIT_CODE}
