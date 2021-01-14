# alpine-cloudplow

[![License: GPL v3](https://img.shields.io/badge/License-GPL%203-blue.svg?style=flat)](https://github.com/sabrsorensen/alpine-cloudplow/blob/main/LICENSE)
[![Container Build](https://img.shields.io/github/workflow/status/sabrsorensen/alpine-cloudplow/Build%20and%20push%20image?label=Container%20Build)](https://github.com/sabrsorensen/alpine-cloudplow/actions?query=workflow%3A%22Build+and+push+image%22)
[![Rebuild for Upstream Updates](https://img.shields.io/github/workflow/status/sabrsorensen/alpine-cloudplow/Rebuild%20with%20upstream%20updates?label=Rebuild%20for%20Upstream%20Updates)](https://github.com/sabrsorensen/alpine-cloudplow/actions?query=workflow%3A%22Rebuild+with+upstream+updates%22)
[![rclone version](https://img.shields.io/github/v/release/rclone/rclone?label=rclone%20version)](https://hub.docker.com/r/rclone/rclone)

A Docker image for the [cloudplow](https://github.com/l3uddz/cloudplow) cloud media sync service, using [rclone's official Docker image](https://hub.docker.com/r/rclone/rclone) based on Alpine Linux as a foundation.

## Application

[cloudplow](https://github.com/l3uddz/cloudplow)

[rclone](https://github.com/rclone/rclone)

## Description

Cloudplow is an automatic rclone remote uploader with support for scheduled transfers, multiple remote/folder pairings, UnionFS control file cleanup, and synchronization between rclone remotes.

## Usage

Sample docker-compose.yml configuration, where the host's rclone.conf is stored in ~/.config/rclone, one or more Google Drive service account .json files is located in ~/google_drive_service_accounts, and media to upload is stored in /imported_media:

```yaml
cloudplow:
  image: sabrsorensen/alpine-cloudplow
  container_name: cloudplow
  environment:
    - PUID=`id -u cloudplow`
    - PGID=`id -g cloudplow`
    - CLOUDPLOW_CONFIG=/config/config.json
    - CLOUDPLOW_LOGFILE=/config/cloudplow.log
    - CLOUDPLOW_LOGLEVEL=DEBUG
    - CLOUDPLOW_CACHEFILE=/config/cache.db
  volumes:
    - /opt/cloudplow:/config/:rw
    - /home/<user>/.config/rclone:/rclone_config/:rw
    - /home/<user>/google_drive_service_accounts:/service_accounts/:rw
    - /imported_media:/data/imported_media:rw
    - /etc/localtime:/etc/localtime:ro
  restart: unless-stopped
```

Upon first run, the container will generate a sample config.json in the container's /config. Edit this config.json to your liking, making sure to set rclone_config_path to the location of the rclone.conf you mapped into the container. Some suggested settings for uploading to a remote, but not synchronizing between remotes, are given below:

```json
    "core": {
        ...
        "rclone_binary_path": "/usr/bin/rclone",
        "rclone_config_path": "/rclone_config/rclone.conf"
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
            ],
            "service_account_path":"/service_accounts/"
        },
        ...
    }
}
```

Please refer to the official [cloudplow](https://github.com/l3uddz/cloudplow) documentation for additional information.
