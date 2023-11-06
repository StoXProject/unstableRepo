#!/bin/bash

# We automatically increment the package version for every successful pull request that merged to master
# This happens only if the current package version is already released (tagged)

PKGVER=$(/usr/bin/sed -n "s/Version: *\([^ ]*\)/\1/p" DESCRIPTION)
PKGNAME=$(/usr/bin/sed -n "s/Package: *\([^ ]*\)/\1/p" DESCRIPTION)
TAG=${PKGNAME}-v${PKGVER}

echo "Looking for tag $TAG"

git fetch --tags

HEAD_COMMIT=$(git rev-parse HEAD)
IS_TAG=$(git show-ref --tags $TAG | /usr/bin/cut -d" " -f1)

export FINAL_TAG=$TAG

echo "Final tag is $FINAL_TAG"
