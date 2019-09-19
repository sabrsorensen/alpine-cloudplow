# alpine-cloudplow
Docker image for the cloudplow cloud media sync service, based on the official rclone/rclone Docker image.

Sample docker-compose.yml configuration, where the host's rclone.conf is stored in ~/.config/rclone and media to upload is stored in /imported_media:
```
    cloudplow:
        image: sabrsorensen/alpine-cloudplow
        container_name: cloudplow
        networks:
            - net
        volumes:
            - /opt/cloudplow:/config/:rw
            - /home/<user>/.config/rclone:/config/rclone/:rw
            - /imported_media:/data/imported_media:rw
            - /etc/localtime:/etc/localtime:ro
        restart: unless-stopped
```

Upon first run, the container will generate a sample config.json in the container's /config. Edit this config.json to your liking, making sure to set rclone_config_path to the location of the rclone.conf you mapped into the container.

