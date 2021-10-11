1. Install Price Feed

- `helm install price-feed-56 --set nameOverride="bsc" helm/price-feed`
- `helm install price-feed-43114 --set nameOverride="avax" helm/price-feed`

2. Install Apr Feed
- `helm install apr-feed-56 --set nameOverride="bsc" helm/apr-feed`
- `helm install apr-feed-43114 --set nameOverride="avax" helm/apr-feed`
