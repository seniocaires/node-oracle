#!/bin/bash

local last_check_date_number=$(cat last_check_date_file)
local this_check_date_number=$(date +"%Y%m%d%H%M%S")

tags_file=/tmp/tags_file.html
tags_url=https://hub.docker.com/r/library/node/tags/
tags_file_list=/tmp/tags_file_list.txt

curl -sSL $tags_url > $tags_file

xmllint --html --noout --nowarning --format --recover --xpath '//div[@class = "FlexTable__flexItem___3vmPs FlexTable__flexItemPadding___2mohd FlexTable__flexItemGrow2___3I1KN"]' $tags_file > $tags_file_list

let imageNameCount=$(xmllint --html --xpath 'count(//div)' $tags_file_list)

echo "Total de imagens="$imageNameCount

declare -a imageName=( )

for (( i=2; i < $imageNameCount; i++ )); do 
    echo $(xmllint --html --xpath '//div['$i']/text()' $tags_file_list)
    tag=$(xmllint --html --xpath '//div['$i']/text()' $tags_file_list)
    ./build-image.sh library/node $tag $last_check_date_number
done

echo $this_check_date_number > last_check_date_file
