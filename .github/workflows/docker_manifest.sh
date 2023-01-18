#!/bin/bash

docker manifest create ghcr.io/${GITHUB_REPOSITORY}:${GITHUB_SHA:0:7} \
    ghcr.io/${GITHUB_REPOSITORY}:${GITHUB_REF//refs\/heads\//}-${GITHUB_SHA:0:7}-amd64 \
    ghcr.io/${GITHUB_REPOSITORY}:${GITHUB_REF//refs\/heads\//}-${GITHUB_SHA:0:7}-arm-v7 \
    ghcr.io/${GITHUB_REPOSITORY}:${GITHUB_REF//refs\/heads\//}-${GITHUB_SHA:0:7}-arm64
docker manifest push ghcr.io/${GITHUB_REPOSITORY}:${GITHUB_SHA:0:7}

if [[ ${GITHUB_REF//refs\/heads\//} == "main" ]]
then
    docker manifest create ghcr.io/${GITHUB_REPOSITORY}:latest \
        ghcr.io/${GITHUB_REPOSITORY}:${GITHUB_REF//refs\/heads\//}-${GITHUB_SHA:0:7}-amd64 \
        ghcr.io/${GITHUB_REPOSITORY}:${GITHUB_REF//refs\/heads\//}-${GITHUB_SHA:0:7}-arm-v7 \
        ghcr.io/${GITHUB_REPOSITORY}:${GITHUB_REF//refs\/heads\//}-${GITHUB_SHA:0:7}-arm64
    docker manifest push ghcr.io/${GITHUB_REPOSITORY}:latest

    docker manifest create ghcr.io/${GITHUB_REPOSITORY}:amd64 \
        ghcr.io/${GITHUB_REPOSITORY}:${GITHUB_REF//refs\/heads\//}-${GITHUB_SHA:0:7}-amd64
    docker manifest push ghcr.io/${GITHUB_REPOSITORY}:amd64

    docker manifest create ghcr.io/${GITHUB_REPOSITORY}:arm-v7 \
        ghcr.io/${GITHUB_REPOSITORY}:${GITHUB_REF//refs\/heads\//}-${GITHUB_SHA:0:7}-arm-v7
    docker manifest push ghcr.io/${GITHUB_REPOSITORY}:arm-v7

    docker manifest create ghcr.io/${GITHUB_REPOSITORY}:arm64 \
        ghcr.io/${GITHUB_REPOSITORY}:${GITHUB_REF//refs\/heads\//}-${GITHUB_SHA:0:7}-arm64
    docker manifest push ghcr.io/${GITHUB_REPOSITORY}:arm64
else
    docker manifest create ghcr.io/${GITHUB_REPOSITORY}:${GITHUB_REF//refs\/heads\//} \
        ghcr.io/${GITHUB_REPOSITORY}:${GITHUB_REF//refs\/heads\//}-${GITHUB_SHA:0:7}-amd64 \
        ghcr.io/${GITHUB_REPOSITORY}:${GITHUB_REF//refs\/heads\//}-${GITHUB_SHA:0:7}-arm-v7 \
        ghcr.io/${GITHUB_REPOSITORY}:${GITHUB_REF//refs\/heads\//}-${GITHUB_SHA:0:7}-arm64
    docker manifest push ghcr.io/${GITHUB_REPOSITORY}:${GITHUB_REF//refs\/heads\//}
fi