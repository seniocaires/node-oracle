#!/bin/bash

set -o errexit

main() {
  check_args "$@"

  local image=$1
  local tag=$2
  local token=$(get_token $image)
  local digest=$(get_digest $image $tag $token)
  pull_image $image $token $digest
}

pull_image() {

  local image=$1
  local token=$2
  local digest=$3
  local image_date=$(get_image_created_date $image $token $digest)
  local last_check_date_number=$(cat last_check_date_file)
  local this_check_date_number=$(date +"%Y%m%d%H%M%S");

  local image_date_number=${image_date%%.*}
  image_date_number="${image_date_number//:}"
  image_date_number="${image_date_number//-}"
  image_date_number="${image_date_number//T}"
  image_date_number="${image_date_number//Z}"

  echo $this_check_date_number"=this_check_date"
  echo $last_check_date_number"=last_check_date_number"
  echo $image_date_number"=image_date_number"

  if (( $(($image_date_number)) >= $(($last_check_date_number)) ));
     then
        docker pull $image":"$tag;
        docker build --build-arg TAG_VERSION=$tag -t seniocaires/node-oracle":"$tag .;
#        docker push seniocaires/node-oracle":"$tag;
#        docker image prune -f;
        echo $this_check_date_number > last_check_date_file
  fi

}

get_image_created_date() {
  local image=$1
  local token=$2
  local digest=$3

  curl \
    --silent \
    --location \
    --header "Authorization: Bearer $token" \
    "https://registry-1.docker.io/v2/$image/blobs/$digest" \
    | jq -r '.created'
}

get_token() {
  local image=$1

  curl \
    --silent \
    "https://auth.docker.io/token?scope=repository:$image:pull&service=registry.docker.io" \
    | jq -r '.token'
}

get_digest() {
  local image=$1
  local tag=$2
  local token=$3

  curl \
    --silent \
    --header "Accept: application/vnd.docker.distribution.manifest.v2+json" \
    --header "Authorization: Bearer $token" \
    "https://registry-1.docker.io/v2/$image/manifests/$tag" \
    | jq -r '.config.digest'
}

check_args() {
  if (($# != 2)); then
    echo "Error:
            Two arguments must be provided - $# provided.
  
            Usage:
               ./build-image.sh <image> <tag>
      
            Aborting."
    exit 1
  fi
}

main "$@"
