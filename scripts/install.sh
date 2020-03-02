#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

if [[ ! -e "scripts" ]]; then
    echo "This script should be executed from project root"
    exit 2
fi

if [[ -z "$PREFIX" ]]; then
    echo "No prefix specified, you should do this before installation:"
    echo "source local.env"
    exit 2
fi

echo "Installing hadoop in $PREFIX"

echo
echo "Extracting files..."
tar -xzf cluster/hadoop-2.8.5.tar.gz -C cluster
rm cluster/hadoop-2.8.5.tar.gz

# workdir cluster
pushd cluster

# install & setup hadoop
echo
echo "Running cluster/install.sh..."
chmod +x install.sh
./install.sh

# entrypoints (setup + teardown on ctrl+c) for master and slave
chmod +x master.sh
chmod +x slave.sh

# back to project root
popd
