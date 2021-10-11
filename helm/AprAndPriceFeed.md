1. Install Price Feed

- `helm install price-fee-56 --set nameOverride="bsc" helm/price-feed`
- `helm install price-fee-43114 --set nameOverride="avax" helm/price-feed`

2. Install Apr Feed
- `helm install apr-fee-56 --set nameOverride="bsc" helm/apr-feed`
- `helm install apr-fee-43114 --set nameOverride="avax" helm/apr-feed`
