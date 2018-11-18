#!/bin/bash

# apt-get install libxml2-utils
export XMLLINT_INDENT=\ \ \ \ 

tags_file=/tmp/tags_file.html
tags_url=https://hub.docker.com/r/library/node/tags/
tags_file_list=/tmp/tags_file_list.txt

curl -sSL $tags_url > $tags_file

#cat $tags_file | grep "class=\"FlexTable__flexItem___3vmPs FlexTable__flexItemPadding___2mohd FlexTable__flexItemGrow2___3I1KN\"" | cut -d'>' -f1
# xmllint --html --noout --nowarning --format --recover --xpath '//div[@class = "FlexTable__flexItem___3vmPs FlexTable__flexItemPadding___2mohd FlexTable__flexItemGrow2___3I1KN"]/text()' $tags_file # - 2>/dev/null # > $tags_file_list #- 2>/dev/null

#xmllint --shell $tags_file <<< 'cat //div/@FlexTable__flexItemGrow2___3I1KN' # | { read -r diag; while { read -r separator; read -r line; } ; do echo "${line}" ; done ; } > $tags_file_list
#xmllint --html --noout --nowarning --format --recover --xpath '//div[@class = "FlexTable__flexItem___3vmPs FlexTable__flexItemPadding___2mohd FlexTable__flexItemGrow2___3I1KN"]' $tags_file > $tags_file_list
#xmllint --shell $tags_file_list <<< 'cat //div[@class = "FlexTable__flexItem___3vmPs FlexTable__flexItemPadding___2mohd FlexTable__flexItemGrow2___3I1KN"]/text()'


xmllint --html --noout --nowarning --format --recover --xpath '//div[@class = "FlexTable__flexItem___3vmPs FlexTable__flexItemPadding___2mohd FlexTable__flexItemGrow2___3I1KN"]' $tags_file > $tags_file_list

let imageNameCount=$(xmllint --html --xpath 'count(//div)' $tags_file_list)

echo $imageNameCount

declare -a imageName=( )

for (( i=2; i < $imageNameCount; i++ )); do 
#    imageName[$i]="$(xmllint --html --xpath '//div['$i']/text()' $tags_file_list)"
    echo $(xmllint --html --xpath '//div['$i']/text()' $tags_file_list)
done

#echo ${imageName[@]}
