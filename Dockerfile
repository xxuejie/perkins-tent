FROM rust:1.40 as builder
MAINTAINER Xuejie Xiao <xxuejie@gmail.com>

RUN git clone https://github.com/xxuejie/ckb-graphql-server /ckb-graphql-server
RUN cd /ckb-graphql-server && git checkout becbc890bda8bb1aff63456bbd2d09ff23e1daff && cargo build --release

FROM debian:buster
MAINTAINER Xuejie Xiao <xxuejie@gmail.com>

RUN apt-get update
RUN apt-get -y install --no-install-recommends wget gnupg ca-certificates unzip software-properties-common
RUN wget -O - https://openresty.org/package/pubkey.gpg | apt-key add -
RUN add-apt-repository -y "deb http://openresty.org/package/debian $(lsb_release -sc) openresty"
RUN apt-get update
RUN apt-get -y install --no-install-recommends openresty

COPY --from=builder /ckb-graphql-server/target/release/ckb-graphql-server /bin/ckb-graphql-server

RUN wget https://github.com/nervosnetwork/ckb/releases/download/v0.26.0/ckb_v0.26.0_x86_64-unknown-linux-gnu.tar.gz -O /tmp/ckb_v0.26.0_x86_64-unknown-linux-gnu.tar.gz
RUN cd /tmp && tar xzf ckb_v0.26.0_x86_64-unknown-linux-gnu.tar.gz
RUN cp /tmp/ckb_v0.26.0_x86_64-unknown-linux-gnu/ckb /bin/ckb

RUN mkdir /tmp/goreman && wget https://github.com/mattn/goreman/releases/download/v0.3.4/goreman_linux_amd64.zip -O /tmp/goreman/goreman_linux_amd64.zip
RUN cd /tmp/goreman && unzip goreman_linux_amd64.zip
RUN cp /tmp/goreman/goreman /bin/goreman

RUN rm -rf /tmp/ckb_v0.26.0_x86_64-unknown-linux-gnu/ckb /tmp/goreman
RUN apt-get -y remove wget gnupg ca-certificates unzip software-properties-common && apt-get -y autoremove && apt-get clean

RUN mkdir /data
COPY nginx.conf /data/nginx.conf
COPY setup.sh /data/setup.sh
COPY Procfile /data/Procfile

# CKB network port
EXPOSE 8115
# OpenResty port
EXPOSE 9115

CMD ["bash", "-c", "/data/setup.sh && exec goreman -set-ports=false -f /data/Procfile start"]
