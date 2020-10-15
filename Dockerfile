FROM debian:stable AS builder

ENV XMR_VER=0.17.1.0
ENV XMR_SHA256=b7b573ff3d2013527fce47643a6738eaf55f10894fa5b2cb364ba5cd937af92e
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update && apt-get -y install wget bzip2

WORKDIR /app

RUN wget https://dlsrc.getmonero.org/cli/monero-linux-x64-v$XMR_VER.tar.bz2 && \
    wget https://www.getmonero.org/downloads/hashes.txt && \
    echo -n "$XMR_SHA256  monero-linux-x64-v$XMR_VER.tar.bz2" | sha256sum --check && \
    tar -xjvf monero-linux-x64-v$XMR_VER.tar.bz2 && \
    cp ./monero-x86_64-linux-gnu-v$XMR_VER/monerod . &&\
    rm -rf monero-*


FROM debian:stable

RUN addgroup monero && \
    adduser --home /app --shell /usr/sbin/nologin --ingroup monero --system monero && \
    chown -R monero:monero /app
USER monero

COPY --from=builder --chown=monero:monero /app/monerod /app/monerod
EXPOSE 18080 18081

ENTRYPOINT ["./app/monerod"]
CMD ["--rpc-bind-ip=0.0.0.0", "--rpc-ssl=enabled", "--restricted-rpc", "--confirm-external-bind", "--data-dir=/app", "--non-interactive", "--no-zmq", "--enforce-dns-checkpointing", "--log-level=1"]
