# run a Monero full node with docker

:heavy_check_mark: Debian stable

:heavy_check_mark: binary sha256 checked against Monero [hashes.txt](https://www.getmonero.org/downloads/hashes.txt)

:heavy_check_mark: secure monerod flags 



```bash
docker run -it -d \
  --name monerod
  -v xmr_data:/data \
  -p 18080:18080 \
  -p 18081:18081 \ #optional, for RPC
  --restart unless-stopped \ 
  iofq/monero-node
```
