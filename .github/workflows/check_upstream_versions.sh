#!/bin/bash

image_cloudplow_ref=`docker run $GITHUB_REPOSITORY "git --work-tree=/opt/cloudplow rev-parse HEAD"`
image_s6_release=`docker run $GITHUB_REPOSITORY "cat /etc/S6_RELEASE"`

current_cloudplow_ref=`curl -sX GET "https://api.github.com/repos/l3uddz/cloudplow/commits/develop" | jq '.sha' | tr -d '"'`
current_s6_release=`curl -sX GET "https://api.github.com/repos/just-containers/s6-overlay/releases/latest" | jq '.tag_name' | tr -d '"'`

if [ `docker run $GITHUB_REPOSITORY "rclone version --check" | grep -P "yours|latest" | awk '{print $2}' | uniq | wc -l` == 2 ]
then
    echo "New version of rclone is available."
    build=1
fi
if [ $image_cloudplow_ref != $current_cloudplow_ref ]
then
    echo "New version of cloudplow is available."
    build=1
fi
if [ $image_s6_release != $current_s6_release ]
then
    echo "New version of s6-overlay is available."
    build=1
fi

if [[ $build ]]
then
    echo "Triggering build."
    echo "::set-output name=build::true"
else
    echo "No build needed."
    echo "::set-output name=build::false"
fi
