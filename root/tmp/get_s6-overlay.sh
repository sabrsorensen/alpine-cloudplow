#!/bin/sh

if [ -n $ARCH ]
then
  s6_arch=$ARCH
else
  s6_arch="amd64"
fi

case "$s6_arch" in
  arm-v7)
    s6_arch="armhf"
    ;;
  arm64)
    s6_arch="aarch64"
    ;;
  amd64)
    s6_arch="amd64"
    ;;
esac
curl -sX GET "https://api.github.com/repos/just-containers/s6-overlay/releases/latest" | awk '/tag_name/{print $4;exit}' FS='[""]' >/etc/S6_RELEASE && \
s6_url="https://github.com/just-containers/s6-overlay/releases/download/`cat /etc/S6_RELEASE`/s6-overlay-$s6_arch.tar.gz"
echo "Downloading from $s6_url" && \
wget $s6_url -O /tmp/s6-overlay.tar.gz && \
tar xzf /tmp/s6-overlay.tar.gz -C / && \
rm /tmp/s6-overlay.tar.gz && \
echo "Installed s6-overlay `cat /etc/S6_RELEASE` ($s6_arch)"
