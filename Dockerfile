FROM rclone/rclone:beta
MAINTAINER sabrsorensen@gmail.com

# linking the base image's rclone binary to the path expected by cloudplow's default config
RUN ln /usr/local/bin/rclone /usr/bin/rclone

WORKDIR /

# install dependencies for cloudplow and start script, upgrade pip
RUN apk -U add git python3 py3-pip grep && \
    python3 -m pip install --upgrade pip

# configure environment variables to keep the start script clean
ENV CLOUDPLOW_CONFIG /config/config.json
ENV CLOUDPLOW_LOGFILE /config/cloudplow.log
ENV CLOUDPLOW_LOGLEVEL DEBUG
ENV CLOUDPLOW_CACHEFILE /config/cache.db

# download cloudplow
RUN git clone --depth 1 --single-branch --branch master https://github.com/l3uddz/cloudplow /opt/cloudplow && \
    cd /opt/cloudplow && \
    # install pip requirements
    python3 -m pip install --no-cache-dir -r requirements.txt

ADD start-cloudplow.sh /
RUN chmod +x /start-cloudplow.sh

# Haven't determined a suitable healthcheck yet
#ADD healthcheck-cloudplow.sh /
#RUN chmod +x /healthcheck-cloudplow.sh

# map /config to host defined config path (used to store configuration from app)
VOLUME /config

ENTRYPOINT ["/bin/sh", "/start-cloudplow.sh"]

#HEALTHCHECK --interval=20s --timeout=10s --start-period=10s --retries=5 \
#    CMD ["/bin/sh", "/healthcheck-cloudplow.sh"]
