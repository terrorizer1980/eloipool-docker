#!/bin/sh
set -e

# Create config file if it doesn't already exist
if [ ! -f "/home/user/eloipool_data/config.py" ]; then
    mkdir -p /home/user/eloipool_data
    envsubst < /tmp/config.py > /home/user/eloipool_data/config.py
fi

# Change local user id and group
if [ -n "${LOCAL_USER_ID}" ] && [ "$(id -u user)" != "${LOCAL_USER_ID}" ]; then
    usermod -u "$LOCAL_USER_ID" user
fi
if [ -n "${LOCAL_GROUP_ID}" ]; then
    groupmod -g "$LOCAL_GROUP_ID" user
fi

# Fix ownership
chown -R user:user /home/user

# Start eloipool
exec sudo -u user -- sh -c "$@"
