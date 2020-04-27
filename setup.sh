#!/bin/bash
set -ex

[ -d /data/mainnet ] || ckb init -c mainnet -C /data/mainnet
if [ ! -d /data/confs ]; then
    cp -r /confs /data/confs
    sed -i s/@INDEXER_RPC_RATE/$RPC_RATE/ /data/confs/nginx.conf
    sed -i s/@RPC_RATE/$RPC_RATE/ /data/confs/nginx.conf
    sed -i s/@GRAPHQL_RATE/$GRAPHQL_RATE/ /data/confs/nginx.conf
fi
