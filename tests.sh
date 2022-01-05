
#!/usr/bin/env bash

IMAGE_NAME="local/docker-satis"
VERSION="3.4.0-debian-bullseye-php81-composer2"
CONTAINER_NAME="satis-test"
EXIT_CODE=0

function check_errors() {
  [[ "$1" == "0" ]] || EXIT_CODE=$?
}

function build() {
  docker build --build-arg BUILD_FROM=mirror.gcr.io/library/debian:bullseye -t "${IMAGE_NAME}:${VERSION}" .
  check_errors $?
}

function run() {
  docker rm -f "${CONTAINER_NAME}" || true

  docker run -p 8080:80 -itd --name "${CONTAINER_NAME}" "${IMAGE_NAME}:${VERSION}"
  check_errors $?

  sleep 5 # Here to wait for entrypoint execution

  docker exec -it "${CONTAINER_NAME}" ./scripts/build.sh
  check_errors $?

  echo "Check GET access to URL"
  curl --connect-timeout 2 --max-time 3 -IkL -X GET "http://127.0.0.1:8080" | grep -Ei "HTTP/1.1 200 OK"
  check_errors $?

  echo "Check GET access to ADMIN URL"
  curl --connect-timeout 2 --max-time 3 -IkL -X GET "http://127.0.0.1:8080/admin" | grep -Ei "HTTP/1.1 200 OK"
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
