FROM rust:1.41 as builder
MAINTAINER Xuejie Xiao <xxuejie@gmail.com>

RUN apt-get update
RUN apt-get -y install --no-install-recommends llvm-dev clang libclang-dev

RUN git clone https://github.com/quake/ckb-indexer /ckb-indexer
RUN cd /ckb-indexer && git checkout 60d397cf0d3e79f8d82f1e996644d870b1493401 && cargo build --release

FROM debian:buster
MAINTAINER Xuejie Xiao <xxuejie@gmail.com>

RUN apt-get update
RUN apt-get -y install --no-install-recommends wget gnupg ca-certificates unzip software-properties-common
RUN wget -O - https://openresty.org/package/pubkey.gpg | apt-key add -
RUN add-apt-repository -y "deb http://openresty.org/package/debian $(lsb_release -sc) openresty"
RUN apt-get update
RUN apt-get -y install --no-install-recommends openresty libssl1.1

COPY --from=builder /ckb-indexer/target/release/ckb-indexer /bin/ckb-indexer

RUN wget https://github.com/nervosnetwork/ckb/releases/download/v0.38.1/ckb_v0.38.1_x86_64-unknown-linux-gnu.tar.gz -O /tmp/ckb_v0.38.1_x86_64-unknown-linux-gnu.tar.gz
RUN cd /tmp && tar xzf ckb_v0.38.1_x86_64-unknown-linux-gnu.tar.gz
RUN cp /tmp/ckb_v0.38.1_x86_64-unknown-linux-gnu/ckb /bin/ckb

RUN mkdir /tmp/goreman && wget https://github.com/mattn/goreman/releases/download/v0.3.4/goreman_linux_amd64.zip -O /tmp/goreman/goreman_linux_amd64.zip
RUN cd /tmp/goreman && unzip goreman_linux_amd64.zip
RUN cp /tmp/goreman/goreman /bin/goreman

RUN wget https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64.deb -O /tmp/dumb-init.deb
RUN dpkg -i /tmp/dumb-init.deb

RUN rm -rf /tmp/ckb_v0.38.1_x86_64-unknown-linux-gnu/ckb /tmp/goreman /tmp/dumb-init.deb
RUN apt-get -y remove wget gnupg ca-certificates unzip software-properties-common && apt-get -y autoremove && apt-get clean

ENV ENABLE_RATE_LIMIT true
ENV RPC_RATE 2
ENV INDEXER_RPC_RATE 5

ENV ENABLE_INDEXER true

ENV CKB_NETWORK mainnet

RUN mkdir /data
RUN mkdir /confs
COPY nginx.conf /confs/nginx.conf
COPY setup.sh /confs/setup.sh
COPY Procfile /confs/Procfile

# CKB network port
EXPOSE 8115
# OpenResty port
EXPOSE 9115

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["bash", "-c", "/confs/setup.sh && exec goreman -set-ports=false -exit-on-error -f /data/confs/Procfile start"]
