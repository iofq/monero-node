# Run a public Monero node in docker

:heavy_check_mark: Debian stable

:heavy_check_mark: automatically fetches latest release on every non-cached build

:heavy_check_mark: binary sha256 checked against Monero [hashes.txt](https://www.getmonero.org/downloads/hashes.txt)

:heavy_check_mark: secure monerod flags 


```bash
docker build --no-cache -t monerod . && \
docker run -d \
  --name monerod \
  -v xmr_data:/monero \
  -p 18080:18080 \
  -p 18081:18081 \ 
  --restart unless-stopped \ 
  monerod
```
