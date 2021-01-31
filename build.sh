#!/bin/bash

REPOSITORY="can/brouter"
VERSION="1.3.2"

BRANCH=$(git rev-parse --abbrev-ref HEAD)
BRANCH="${BRANCH/\//-}"

if [ "$BRANCH" = "master" ]; then
    TAGS=("$VERSION" "latest")
else
    TAGS=("${VERSION}-${BRANCH}" "dev")
fi;

docker build ${TAGS[@]/#/--tag $REPOSITORY:} .
