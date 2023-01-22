FROM rclone/rclone

ARG BUILD_DATE="unknown"
ARG COMMIT_AUTHOR="unknown"
ARG VCS_REF="unknown"
ARG VCS_URL="unknown"
ARG ARCH="amd64"

LABEL maintainer=${COMMIT_AUTHOR} \
    org.label-schema.vcs-ref=${VCS_REF} \
    org.label-schema.vcs-url=${VCS_URL} \
    org.label-schema.build-date=${BUILD_DATE}

# linking the base image's rclone binary to the path expected by cloudplow's default config
RUN ln /usr/local/bin/rclone /usr/bin/rclone

# configure environment variables to keep the start script clean
ENV CLOUDPLOW_CONFIG=/config/config.json CLOUDPLOW_LOGFILE=/config/cloudplow.log CLOUDPLOW_LOGLEVEL=DEBUG CLOUDPLOW_CACHEFILE=/config/cache.db

# map /config to host directory containing cloudplow config (used to store configuration from app)
VOLUME /config

# map /rclone_config to host directory containing rclone configuration files
VOLUME /rclone_config

# map /service_accounts to host directory containing Google Drive service account .json files
VOLUME /service_accounts

# map /data to media queued for upload
VOLUME /data

# install dependencies for cloudplow and user management, upgrade pip
RUN apk -U add --no-cache \
    coreutils \
    findutils \
    git \
    grep \
    py3-pip \
    python3 \
    shadow \
    tzdata && \
    python3 -m pip install --no-cache-dir --upgrade pip wheel

# add s6-overlay scripts and config
ADD root/ /

# install s6-overlay for process management
RUN apk -Uq --no-cache add curl && \
    /tmp/get_s6-overlay.sh && \
    rm /tmp/get_s6-overlay.sh && \
    apk -q del curl

# download cloudplow
RUN git clone --depth 1 --single-branch --branch develop https://github.com/l3uddz/cloudplow /opt/cloudplow

WORKDIR /opt/cloudplow
ENV PATH=/opt/cloudplow:${PATH}
RUN git config pull.ff only

# install pip requirements
RUN python3 -m pip install --no-cache-dir --upgrade -r requirements.txt

ENTRYPOINT ["/bin/sh", "-c"]
CMD ["/init"]
