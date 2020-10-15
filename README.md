# run a monero full node with docker

* Debian Stable
* sha256 checked against monero [hashes.txt](https://www.getmonero.org/downloads/hashes.txt)
* secure monerod flags 

TODO: separate monerod from data directory
      upload to docker hub

```bash
docker run -it \
  -name=monerod
  -v data_dir:/app \
  -p 18080:18080 \
  -p 18081:18081 \ #optional, for RPC
  --restart=unless-stopped \ 
  iofq/monero-node
