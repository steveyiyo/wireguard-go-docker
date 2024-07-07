#!/bin/bash

finish () {
    for conf in /etc/wireguard/*.conf; do
        interface=$(basename "${conf}" .conf)
        wg-quick down "${interface}"
    done
    exit 0
}
trap finish SIGTERM SIGINT SIGQUIT

for conf in /etc/wireguard/*.conf; do
    wg-quick up "${conf}"
done

# Infinite sleep
sleep infinity &

# Health check
if [[ -n "${ENABLE_HEALTHCHECK}" ]]; then
    /usr/bin/healthcheck &
fi

wait $!
