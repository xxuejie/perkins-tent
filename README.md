Perkins' Tent
=============

Reference: https://harrypotter.fandom.com/wiki/Perkins%27s_tent

This repository provides a docker image containing the following pieces:

* [ckb](https://github.com/nervosnetwork/ckb)
* [ckb-graphql-server](https://github.com/xxuejie/ckb-graphql-server)
* [OpenResty](https://github.com/openresty/openresty) which reverse-proxies and rate-limits CKB RPC as well ckb-graphql-server requests.

The idea is that anyone can create a server with the docker image which serves CKB to the general public.

While right now we are providing only basic setups, we might expand this later with more features such as:

* Rate-limiting configurations
* Token-based ACL
