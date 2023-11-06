#!/bin/bash

# We automatically increment the package version for every successful pull request that merged to master
# This happens only if the current package version is already released (tagged)

PKGVER=$(sed -n "s/Version: *\([^ ]*\)/\1/p" DESCRIPTION)
PKGNAME=$(sed -n "s/Package: *\([^ ]*\)/\1/p" DESCRIPTION)
TAG=${PKGNAME}-v${PKGVER}

if [[ ${PKGVER} == *-* ]]; 
then
  PRERELEASE=true
else
  PRERELEASE=false
fi

echo "$PRERELEASE"

echo "Looking for tag $TAG"

git fetch -f --tags

HEAD_COMMIT=$(git rev-parse HEAD)

IS_TAG=$((git show-ref --tags $TAG || echo "")| cut -d" " -f1)

echo "We have: $HEAD_COMMIT : $IS_TAG" 

export FINAL_TAG=$TAG
export PKG_FILE_PREFIX=${PKGNAME}_${PKGVER}
export PRERELEASE=$PRERELEASE

echo "Final tag is $FINAL_TAG"
