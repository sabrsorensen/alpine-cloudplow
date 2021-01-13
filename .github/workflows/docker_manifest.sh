#!/bin/bash

docker manifest create ${GITHUB_REPOSITORY}:${GITHUB_SHA:0:7} \
    --amend ${GITHUB_REPOSITORY}:${GITHUB_REF//refs\/heads\//}-${GITHUB_SHA:0:7}-amd64 \
    --amend ${GITHUB_REPOSITORY}:${GITHUB_REF//refs\/heads\//}-${GITHUB_SHA:0:7}-arm-v7 \
    --amend ${GITHUB_REPOSITORY}:${GITHUB_REF//refs\/heads\//}-${GITHUB_SHA:0:7}-arm64
docker manifest push ${GITHUB_REPOSITORY}:${GITHUB_SHA:0:7}
docker manifest create ${GITHUB_REPOSITORY}:latest \
    --amend ${GITHUB_REPOSITORY}:${GITHUB_REF//refs\/heads\//}-${GITHUB_SHA:0:7}-amd64 \
    --amend ${GITHUB_REPOSITORY}:${GITHUB_REF//refs\/heads\//}-${GITHUB_SHA:0:7}-arm-v7 \
    --amend ${GITHUB_REPOSITORY}:${GITHUB_REF//refs\/heads\//}-${GITHUB_SHA:0:7}-arm64
docker manifest push ${GITHUB_REPOSITORY}:latest