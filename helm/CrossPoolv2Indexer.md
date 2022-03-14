# Deploy the indexer

- Connect to the pod

`kubectl -n indexer exec --stdin --tty kafka-0 -- /bin/bash`

- Create a topic

- `kafka-topics.sh --create --topic cross-pool-v2-events-56 --bootstrap-server localhost:9092`
- `kafka-topics.sh --create --topic cross-pool-v2-events-43114 --bootstrap-server localhost:9092`

- Verify the topic was created

`kafka-topics.sh --list --bootstrap-server localhost:9092`

- Run helm install

- `helm install cross-pool-v2-connector-56 --set nameOverride="bsc" helm/cross-pool-v2-connector`
- `helm install cross-pool-v2-consumer-56 --set nameOverride="bsc" helm/cross-pool-v2-consumer`

- `helm install cross-pool-v2-connector-43114 --set nameOverride="avax" helm/cross-pool-v2-connector`
- `helm install cross-pool-v2-consumer-43114 --set nameOverride="avax" helm/cross-pool-v2-consumer`

