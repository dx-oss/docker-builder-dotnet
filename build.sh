#!/bin/bash

pwd=$(pwd)

ORG=dxdx
NAME=docker-builder-dotnet

IMAGE_TAG_PREFIX=$ORG/$NAME:

IMAGE_NETCORE31=mcr.microsoft.com/dotnet/core/sdk:3.1
IMAGE_NETCORE30=mcr.microsoft.com/dotnet/core/sdk:3.0
IMAGE_NETCORE22=mcr.microsoft.com/dotnet/core/sdk:2.2

BRANCH_NETCORE31=sdk-3.1
BRANCH_NETCORE30=sdk-3.0
BRANCH_NETCORE22=sdk-2.2

TAGS_NETCORE31="v3 v3.1 v3.1.2"
TAGS_NETCORE30="v3.0 v3.0.0"
TAGS_NETCORE22="v2 v2.2 v2.2.0"

VERSIONS="NETCORE22 NETCORE30 NETCORE31"
VERSIONS=${1:-$VERSIONS}

function log {
    echo "$*"
}

function run {
    log $*
    eval $*
}

function build {
    local version=$1
    local branch=$2
    local image=$3

    local tag_version=$(echo $image | cut -d":" -f2 | cut -d"-" -f1)
    local tag_major_version=$(echo $branch | cut -d"-" -f2)

    local tag=$ORG/$NAME:$tag_version
    local tag_major=$ORG/$NAME:$tag_major_version

    echo "$version ($branch) ($image) [$tag] [$tag_major]"

    run cp common/* $branch    
    run cd $branch
    run docker build --build-arg '"DOCKER_IMAGE=$image"' -t $tag .
    run docker tag $tag $tag_major
    run docker push $tag
    run docker push $tag_major
    for c in `ls ../common`
    do
        run rm $c
    done 
    run cd $pwd
}

for v in $VERSIONS
do
    branch=BRANCH_$v
    image=IMAGE_$v

    build $v ${!branch} ${!image}
done
