#!/bin/bash
set -ex

[ -d /data/mainnet ] || ckb init -c mainnet -C /data/mainnet
if [ ! -d /data/confs ]; then
    cp -r /confs /data/confs
    sed -i s/@INDEXER_RPC_RATE/$RPC_RATE/ /data/confs/nginx.conf
    sed -i s/@RPC_RATE/$RPC_RATE/ /data/confs/nginx.conf
    sed -i s/@GRAPHQL_RATE/$GRAPHQL_RATE/ /data/confs/nginx.conf

    if [ "$ENABLE_GRAPHQL_SERVER" == "true" ]; then
        echo "graphql: sleep 5; ckb-graphql-server -d /data/mainnet/data/db -l 127.0.0.1:3000" >> /data/confs/Procfile
    fi

    if [ "$ENABLE_INDEXER" == "true" ]; then
        echo "indexer: ckb-indexer -s /data/indexer_db" >> /data/confs/Procfile
    fi
fi
