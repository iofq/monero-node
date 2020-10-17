# run a monero full node with docker

:heavy_check_mark: Debian stable

:heavy_check_mark: sha256 checked against monero [hashes.txt](https://www.getmonero.org/downloads/hashes.txt)

:heavy_check_mark: secure monerod flags 



```bash
docker run -it -d \
  -name=monerod
  -v xmr_data_dir:/data \ #blockchain data
  -p 18080:18080 \
  -p 18081:18081 \ #optional, for RPC
  --restart=unless-stopped \ 
  iofq/monero-node
```
