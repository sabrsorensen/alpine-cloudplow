#!/bin/bash

docker manifest create ${GITHUB_REPOSITORY}:${GITHUB_SHA:0:7} \
    --amend ${GITHUB_REPOSITORY}:${GITHUB_REF//refs\/heads\//}-${GITHUB_SHA:0:7}-amd64 \
    --amend ${GITHUB_REPOSITORY}:${GITHUB_REF//refs\/heads\//}-${GITHUB_SHA:0:7}-arm-v7 \
    --amend ${GITHUB_REPOSITORY}:${GITHUB_REF//refs\/heads\//}-${GITHUB_SHA:0:7}-arm64
docker manifest push ${GITHUB_REPOSITORY}:${GITHUB_SHA:0:7}

if [[ ${GITHUB_REF//refs\/heads\//} == "main" ]]
then
    docker manifest create ${GITHUB_REPOSITORY}:latest \
        --amend ${GITHUB_REPOSITORY}:${GITHUB_REF//refs\/heads\//}-${GITHUB_SHA:0:7}-amd64 \
        --amend ${GITHUB_REPOSITORY}:${GITHUB_REF//refs\/heads\//}-${GITHUB_SHA:0:7}-arm-v7 \
        --amend ${GITHUB_REPOSITORY}:${GITHUB_REF//refs\/heads\//}-${GITHUB_SHA:0:7}-arm64
    docker manifest push ${GITHUB_REPOSITORY}:latest

    docker manifest create ${GITHUB_REPOSITORY}:amd64 \
        --amend ${GITHUB_REPOSITORY}:${GITHUB_REF//refs\/heads\//}-${GITHUB_SHA:0:7}-amd64
    docker manifest push ${GITHUB_REPOSITORY}:amd64

    docker manifest create ${GITHUB_REPOSITORY}:arm-v7 \
        --amend ${GITHUB_REPOSITORY}:${GITHUB_REF//refs\/heads\//}-${GITHUB_SHA:0:7}-arm-v7
    docker manifest push ${GITHUB_REPOSITORY}:arm-v7

    docker manifest create ${GITHUB_REPOSITORY}:arm64 \
        --amend ${GITHUB_REPOSITORY}:${GITHUB_REF//refs\/heads\//}-${GITHUB_SHA:0:7}-arm64
    docker manifest push ${GITHUB_REPOSITORY}:arm64
else
    docker manifest create ${GITHUB_REPOSITORY}:${GITHUB_REF//refs\/heads\//} \
        --amend ${GITHUB_REPOSITORY}:${GITHUB_REF//refs\/heads\//}-${GITHUB_SHA:0:7}-amd64 \
        --amend ${GITHUB_REPOSITORY}:${GITHUB_REF//refs\/heads\//}-${GITHUB_SHA:0:7}-arm-v7 \
        --amend ${GITHUB_REPOSITORY}:${GITHUB_REF//refs\/heads\//}-${GITHUB_SHA:0:7}-arm64
    docker manifest push ${GITHUB_REPOSITORY}:${GITHUB_REF//refs\/heads\//}
fi