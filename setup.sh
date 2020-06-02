#!/bin/bash
set -ex

[ -d /data/ckb-data ] || ckb init -c $CKB_NETWORK -C /data/ckb-data
if [ ! -d /data/confs ]; then
    cp -r /confs /data/confs

    if [ "$ENABLE_RATE_LIMIT" == "true" ]; then
        sed -i s/@INDEXER_RPC_RATE/$INDEXER_RPC_RATE/ /data/confs/nginx.conf
        sed -i s/@RPC_RATE/$RPC_RATE/ /data/confs/nginx.conf
        sed -i s/@GRAPHQL_RATE/$GRAPHQL_RATE/ /data/confs/nginx.conf
    else
        sed -i /limit_req/d /data/confs/nginx.conf
    fi

    if [ "$ENABLE_GRAPHQL_SERVER" == "true" ]; then
        echo "graphql: sleep 5; ckb-graphql-server -d /data/ckb-data/data/db -l 127.0.0.1:3000" >> /data/confs/Procfile
    fi

    if [ "$ENABLE_INDEXER" == "true" ]; then
        echo "indexer: ckb-indexer -s /data/indexer_db" >> /data/confs/Procfile
    fi
fi
