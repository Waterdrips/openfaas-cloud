#!/bin/sh
set -e

# Run this command from one-level higher in the folder path, not this folder.

CLI="faas-cli"
if ! [ -x "$(command -v faas-cli)" ]; then
    HERE=`pwd`
    cd /tmp/
    curl -sL https://github.com/openfaas/faas-cli/releases/download/0.9.3/faas-cli > faas-cli
    chmod +x ./faas-cli
    CLI="/tmp/faas-cli"

    echo "Returning to $HERE"
    cd $HERE
fi

echo "Working folder: `pwd`"

$CLI publish --parallel=4 --platforms linux/amd64,linux/arm64,linux/arm/v7
HERE=`pwd`
cd dashboard
$CLI publish -f stack.yml --platforms linux/amd64,linux/arm64,linux/arm/v7
cd $HERE
$CLI publish -f gitlab.yml --platforms linux/amd64,linux/arm64,linux/arm/v7
$CLI publish -f aws.yml --platforms linux/amd64,linux/arm64,linux/arm/v7