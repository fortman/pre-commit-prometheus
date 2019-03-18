#!/bin/sh

PROMETHEUS_DOCKER_TAG="${1}"
echo "PROMETHEUS_DOCKER_TAG: ${PROMETHEUS_DOCKER_TAG}"
shift
FILES="${*}"
CONTAINER_FILES="$( echo ${FILES} | tr " " "\n" | awk ' { print "/repo/"$0 } ' | tr "\n" " " )"

docker run --entrypoint "/bin/promtool" --volume ${PWD}:/repo prom/prometheus:${PROMETHEUS_DOCKER_TAG} check rules ${CONTAINER_FILES}
