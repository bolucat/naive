#!/bin/bash

DOCKERCOMPOSE="docker compose"
DOCKERCOMPOSEFILE=$(find / -name "docker-naive.yaml" || echo "/etc/naiveproxy/docker-naive.yaml")

${DOCKERCOMPOSE} -f ${DOCKERCOMPOSEFILE} down
${DOCKERCOMPOSE} -f ${DOCKERCOMPOSEFILE} rm -fv
${DOCKERCOMPOSE} -f ${DOCKERCOMPOSEFILE} up