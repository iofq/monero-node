FROM debian:stable AS builder

ENV XMR_VER=0.17.1.0
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update && apt-get -y install wget bzip2

WORKDIR /app

RUN wget https://dlsrc.getmonero.org/cli/monero-linux-x64-v$XMR_VER.tar.bz2 && \
    wget https://www.getmonero.org/downloads/hashes.txt && \
    grep -i "monero-linux-x64-v$XMR_VER.tar.bz2" hashes.txt | sha256sum --check && \
    tar -xjvf monero-linux-x64-v$XMR_VER.tar.bz2 && \
    cp ./monero-x86_64-linux-gnu-v$XMR_VER/monerod . &&\
    rm -rf monero-*

FROM debian:stable

VOLUME /data
RUN addgroup monero && \
    adduser --shell /usr/sbin/nologin --ingroup monero --system monero && \
    mkdir /data && chown -R monero:monero /data && \
COPY --from=builder --chown=monero:monero /app/monerod /data/monerod

USER monero
EXPOSE 18080 18081

ENTRYPOINT ["./data/monerod"]
CMD ["--rpc-bind-ip=0.0.0.0", "--rpc-ssl=enabled", "--restricted-rpc", "--confirm-external-bind", "--data-dir=/data", "--non-interactive", "--no-zmq", "--enforce-dns-checkpointing", "--log-level=0"]
