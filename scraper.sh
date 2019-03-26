#!/bin/bash

local last_check_date_number=$(cat last_check_date_file)
local this_check_date_number=$(date +"%Y%m%d%H%M%S")

tags_file=/tmp/tags
tags_url=https://hub.docker.com/r/library/node/tags/
tags_file_list=/tmp/tags_file_list.txt

wget -q https://registry.hub.docker.com/v1/repositories/node/tags -O -  | sed -e 's/[][]//g' -e 's/"//g' -e 's/ //g' | tr '}' '\n'  | awk -F: '{print $3}' > $tags_file

imageNameCount=$(wc -l < /tmp/tags)
echo "Total de imagens="$imageNameCount

while read tag; do
  ./build-image.sh library/node $tag $last_check_date_number
done < $tags_file

echo $this_check_date_number > last_check_date_file
