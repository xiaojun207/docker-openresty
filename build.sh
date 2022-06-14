#!/bin/bash
set -ex

IMAGE=xiaojun207/openresty

# 版本信息来自openresty官方镜像
# https://hub.docker.com/r/openresty/openresty/tags
OPENRESTY_VERSIONS=(
  1.21.4.1
)

function build() {
  OPENRESTY_VERSION=$1

  if [[ $1 =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)\.([0-9]+)$ ]]; then
    MAJOR=${BASH_REMATCH[1]}
    MINOR=${BASH_REMATCH[2]}
    PATCH=${BASH_REMATCH[3]}
  else
    exit 1
  fi

  TAG_LATEST="${MAJOR}.${MINOR}"
  TAG_SPECIAL="${MAJOR}.${MINOR}.${PATCH}"

  docker buildx build \
    --platform linux/amd64,linux/arm64 \
    --build-arg OPENRESTY_VERSION="$OPENRESTY_VERSION" \
    --tag $IMAGE:"latest" \
    --tag $IMAGE:"$TAG_LATEST" \
    --tag $IMAGE:"$TAG_SPECIAL" \
    --push \
    .
}

for OPENRESTY_VERSION in "${OPENRESTY_VERSIONS[@]}"; do
  build "$OPENRESTY_VERSION"
done
