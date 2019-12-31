#!/bin/bash
set -ex

[ -d /data/mainnet ] || ckb init -c mainnet -C /data/mainnet
