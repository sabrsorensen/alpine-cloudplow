#! /bin/sh

if [ ! -f /config/config.json ]
then
    python /plex_autoscan/scan.py sections --config=/config/config.json --loglevel=INFO --cachefile=/config/cache.db --queuefile=/config/queue.db --logfile=/config/plex_autoscan.log
    echo "Default config.json generated, please configure for your environment. Exiting."
else
    server_pass=$(grep SERVER_PASS /config/config.json | awk -F '"' '{print $4}')
    server_port=$(grep SERVER_PORT /config/config.json | awk -F ': ' '{print $2}' | awk -F ',' '{print $1}')
    url="http://localhost:${server_port}/${server_pass}"
    curl --silent --show-error -f $url > /dev/null || exit 1
fi

