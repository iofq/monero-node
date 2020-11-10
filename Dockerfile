FROM debian:stable AS build
ARG DEBIAN_FRONTEND=noninteractive

#only to force hub.docker.com image to rebuild
ENV MONERO_VERSION=0.17.1.3

WORKDIR /root
RUN apt-get -y update && apt-get -y install curl lbzip2 && \
    curl -Os https://www.getmonero.org/downloads/hashes.txt && \ 
    XMR_VER=$(grep 'monero-linux-x64-.*.tar.bz2' hashes.txt | sed -n 's/.*\(v.*\).tar.bz2/\1/p') && \
    curl -Os https://dlsrc.getmonero.org/cli/monero-linux-x64-$XMR_VER.tar.bz2 && \
    grep -i "monero-linux-x64-$XMR_VER.tar.bz2" hashes.txt | sha256sum --check && \
    tar -I lbzip2 -xvf monero-linux-x64-$XMR_VER.tar.bz2 && \
    cp ./monero-x86_64-linux-gnu-$XMR_VER/monerod . && \
    rm -rf monero-*

FROM debian:stable

RUN addgroup monero && \
    adduser --no-create-home --shell /usr/sbin/nologin --ingroup monero --system monero
VOLUME /monero
COPY --from=build --chown=monero:monero /root/monerod /usr/local/bin/monerod

USER monero
EXPOSE 18080 18081

ENTRYPOINT ["monerod"]
CMD ["--rpc-bind-ip=0.0.0.0", "--data-dir=/monero", "--rpc-ssl=enabled", "--restricted-rpc", "--public-node",  "--confirm-external-bind",  "--non-interactive", "--no-zmq", "--enforce-dns-checkpointing", "--log-level=0"]
