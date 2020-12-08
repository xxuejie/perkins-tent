Perkins' Tent
=============

Reference: https://harrypotter.fandom.com/wiki/Perkins%27s_tent

This repository provides a docker image containing the following pieces:

* [ckb](https://github.com/nervosnetwork/ckb)
* [ckb-indexer](https://github.com/quake/ckb-indexer)
* [OpenResty](https://github.com/openresty/openresty) which reverse-proxies and rate-limits CKB RPC.

The idea is that anyone can create a server with the docker image which serves CKB to the general public.

While right now we are providing only basic setups, we might expand this later with more features such as:

* Rate-limiting configurations
* Token-based ACL

# Usage

To start the docker image, you can use the following command:

```bash
$ docker run --rm -p 9115:9115 xxuejie/perkins-tent
```

Right now the image hardcodes port `9115` as the port to listen to, we might revise this later to make it configurable. That said, you can tweak docker's mapping port to listen at other ports. For example, the following command changes the image to listen at port `12345` instead of `9115`:

```bash
$ docker run --rm -p 12345:9115 xxuejie/perkins-tent
```

It's also possible to preserve CKB's data as well as configuration file, the following command maps `/foo/bar` on the host machine into the docker image, so data and configurations can be reused across docker restarts:

```bash
$ docker run --rm -p 9115:9115 -v /foo/bar:/data xxuejie/perkins-tent
```
