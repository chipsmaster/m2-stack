#!/usr/bin/env bash

set -e

script_path="${0%/*}"
root_path="$script_path"

env_path="$root_path/.env"
echo "Regenerating $env_path ..."
if [ -f "$env_path" ]
then
	rm -i "$env_path"
fi

sed "s/#UID#/$(id -u)/" "$root_path/.env.sample" | sed "s/#GID#/$(id -g)/" > "$env_path"

echo "Setting docker-compose.override.yml up"
cp -vi "$root_path/docker-compose.override.sample.yml" "$root_path/docker-compose.override.yml"
