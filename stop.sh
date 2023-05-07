#!/bin/bash

DOCKERCOMPOSE="docker compose"
DOCKERCOMPOSEFILE="/etc/naiveproxy/docker-naive.yaml"

${DOCKERCOMPOSE} -f ${DOCKERCOMPOSEFILE} down
${DOCKERCOMPOSE} -f ${DOCKERCOMPOSEFILE} rm -fv