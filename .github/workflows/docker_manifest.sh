#!/bin/bash

docker manifest create ghcr.io/${GITHUB_REPOSITORY}:${GITHUB_SHA:0:7} \
    --amend ghcr.io/${GITHUB_REPOSITORY}:${GITHUB_REF//refs\/heads\//}-${GITHUB_SHA:0:7}-amd64 \
    --amend ghcr.io/${GITHUB_REPOSITORY}:${GITHUB_REF//refs\/heads\//}-${GITHUB_SHA:0:7}-arm-v7 \
    --amend ghcr.io/${GITHUB_REPOSITORY}:${GITHUB_REF//refs\/heads\//}-${GITHUB_SHA:0:7}-arm64
docker manifest push ghcr.io/${GITHUB_REPOSITORY}:${GITHUB_SHA:0:7}

if [[ ${GITHUB_REF//refs\/heads\//} == "main" ]]
then
    docker manifest create ghcr.io/${GITHUB_REPOSITORY}:latest \
        --amend ghcr.io/${GITHUB_REPOSITORY}:${GITHUB_REF//refs\/heads\//}-${GITHUB_SHA:0:7}-amd64 \
        --amend ghcr.io/${GITHUB_REPOSITORY}:${GITHUB_REF//refs\/heads\//}-${GITHUB_SHA:0:7}-arm-v7 \
        --amend ghcr.io/${GITHUB_REPOSITORY}:${GITHUB_REF//refs\/heads\//}-${GITHUB_SHA:0:7}-arm64
    docker manifest push ghcr.io/${GITHUB_REPOSITORY}:latest

    docker manifest create ghcr.io/${GITHUB_REPOSITORY}:amd64 \
        --amend ghcr.io/${GITHUB_REPOSITORY}:${GITHUB_REF//refs\/heads\//}-${GITHUB_SHA:0:7}-amd64
    docker manifest push ghcr.io/${GITHUB_REPOSITORY}:amd64

    docker manifest create ghcr.io/${GITHUB_REPOSITORY}:arm-v7 \
        --amend ghcr.io/${GITHUB_REPOSITORY}:${GITHUB_REF//refs\/heads\//}-${GITHUB_SHA:0:7}-arm-v7
    docker manifest push ghcr.io/${GITHUB_REPOSITORY}:arm-v7

    docker manifest create ghcr.io/${GITHUB_REPOSITORY}:arm64 \
        --amend ghcr.io/${GITHUB_REPOSITORY}:${GITHUB_REF//refs\/heads\//}-${GITHUB_SHA:0:7}-arm64
    docker manifest push ghcr.io/${GITHUB_REPOSITORY}:arm64
else
    docker manifest create ghcr.io/${GITHUB_REPOSITORY}:${GITHUB_REF//refs\/heads\//} \
        --amend ghcr.io/${GITHUB_REPOSITORY}:${GITHUB_REF//refs\/heads\//}-${GITHUB_SHA:0:7}-amd64 \
        --amend ghcr.io/${GITHUB_REPOSITORY}:${GITHUB_REF//refs\/heads\//}-${GITHUB_SHA:0:7}-arm-v7 \
        --amend ghcr.io/${GITHUB_REPOSITORY}:${GITHUB_REF//refs\/heads\//}-${GITHUB_SHA:0:7}-arm64
    docker manifest push ghcr.io/${GITHUB_REPOSITORY}:${GITHUB_REF//refs\/heads\//}
fi