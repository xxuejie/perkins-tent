#!/bin/bash
set -ex

[ -d /data/mainnet ] || ckb init -c mainnet -C /data/mainnet
[ -d /data/confs ] || cp -r /confs /data/confs
