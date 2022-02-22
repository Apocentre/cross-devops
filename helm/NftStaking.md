
# Deploy the indexer

- Connect to the pod

`kubectl -n indexer exec --stdin --tty kafka-0 -- /bin/bash`

- Create a topic

- `kafka-topics.sh --create --topic nft-staking-events-56 --bootstrap-server localhost:9092`
- `kafka-topics.sh --create --topic nft-staking-events-1 --bootstrap-server localhost:9092`

- Verify the topic was created

`kafka-topics.sh --list --bootstrap-server localhost:9092`

- Run helm install for the indexer

- `helm install nft-staking-connector-56 --set nameOverride="bsc" helm/nft-staking-connector`
- `helm install nft-staking-consumer-56 --set nameOverride="bsc" helm/nft-staking-consumer`

- `helm install nft-staking-connector-1 --set nameOverride="eth" helm/nft-staking-connector`
- `helm install nft-staking-consumer-1 --set nameOverride="eth" helm/nft-staking-consumer`
