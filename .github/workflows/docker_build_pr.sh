#!/bin/bash
TAG=${GITHUB_REF//refs\/pull\//PR}
TAG=${TAG//\/merge/}
docker buildx build \
    --platform ${ARCHITECTURE//-/\/} \
    --output "type=image,push=false" \
    --tag ${GITHUB_REPOSITORY}:${TAG}-${GITHUB_SHA:0:7}-${ARCHITECTURE//linux-/} \
    --build-arg ARCH="${ARCHITECTURE//linux-/}" \
    --build-arg BUILD_DATE="$(date -u +'%Y-%m-%dT%H:%M:%SZ')" \
    --build-arg COMMIT_AUTHOR="$(git log -1 --pretty=format:'%ae')" \
    --build-arg VCS_REF="${GITHUB_SHA}" \
    --build-arg VCS_URL="${GITHUB_SERVER_URL}/${GITHUB_REPOSITORY}" \
    --file ./Dockerfile ./