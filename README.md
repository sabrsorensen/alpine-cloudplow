# alpine-cloudplow
![Docker Automated build](https://img.shields.io/docker/cloud/automated/sabrsorensen/alpine-cloudplow?label=Docker+Cloud+build+type) ![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/sabrsorensen/alpine-cloudplow?label=Docker+Cloud+build+status) ![Docker Pulls](https://img.shields.io/docker/pulls/sabrsorensen/alpine-cloudplow) [![Docker image size](https://images.microbadger.com/badges/image/sabrsorensen/alpine-cloudplow.svg)](https://microbadger.com/images/sabrsorensen/alpine-cloudplow "Get your own image badge on microbadger.com") ![rclone version](https://img.shields.io/github/v/release/rclone/rclone?label=rclone%20version)

A Docker image for the [cloudplow](https://github.com/l3uddz/cloudplow) cloud media sync service, using [rclone's official Docker image](https://hub.docker.com/r/rclone/rclone) based on Alpine Linux as a foundation.

**Application**

[cloudplow](https://github.com/l3uddz/cloudplow)

[rclone](https://github.com/rclone/rclone)


**Description**

Cloudplow is an automatic rclone remote uploader with support for scheduled transfers, multiple remote/folder pairings, UnionFS control file cleanup, and synchronization between rclone remotes.


**Usage**
Sample docker-compose.yml configuration, where the host's rclone.conf is stored in ~/.config/rclone and media to upload is stored in /imported_media:
```
    cloudplow:
        image: sabrsorensen/alpine-cloudplow
        container_name: cloudplow
        volumes:
            - /opt/cloudplow:/config/:rw
            - /home/<user>/.config/rclone:/config/rclone/:rw
            - /imported_media:/data/imported_media:rw
            - /etc/localtime:/etc/localtime:ro
        restart: unless-stopped
```

Upon first run, the container will generate a sample config.json in the container's /config. Edit this config.json to your liking, making sure to set rclone_config_path to the location of the rclone.conf you mapped into the container. Some suggested settings for uploading to a remote, but not synchronizing between remotes, are given below:

```
    "core": {
        ...
        "rclone_binary_path": "/usr/bin/rclone",
        "rclone_config_path": "/config/rclone/rclone.conf"
        ...
    },
    ...
    "plex": {
        ...
        "rclone": {
            ...
            "url": "http://127.0.0.1:7949"
            ...
        },
        ...
        "url": "http://plex:32400" # URL of plex server, this example value specifies a Plex Docker container running on the same host.
        ...
    },
    "remotes": {
        ...
        "media": {
            "rclone_command": "move",
            "rclone_excludes": [
            ],
            "rclone_extras": {
                "--checkers": 4,
                "--drive-chunk-size": "8M",
                "--fast-list": null,
                "--min-age": "1d",
                "--skip-links": null,
                "--stats": "10s",
                "--timeout": "30s",
                "--transfers": 1,
                "--user-agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.131 Safari/537.36",
                "-vv": null
            },
            "rclone_sleeps": {
                "Failed to copy: googleapi: Error 403: User rate limit exceeded": {
                    "count": 5,
                    "sleep": 25,
                    "timeout": 3600
                }
            },
            "remove_empty_dir_depth": 2,
            "sync_remote": "googledrive:/media/",
            "upload_folder": "/data/imported_media",
            "upload_remote": "googledrive:/media/"
        },
        ...
    },
    "syncer": {},
    "uploader": {
        ...
        "media": {
            "check_interval": 30,
            "exclude_open_files": true,
            "max_size_gb": 0,
            "opened_excludes": [
                "/data/imported_media"
            ],
            "schedule": {
                "allowed_from": "01:00",
                "allowed_until": "09:00",
                "enabled": false
            },
            "size_excludes": [
            ]
        },
        ...
    }
}
```

Please refer to the official cloudplow documentation for additional information.
