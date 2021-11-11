**Run command line**

- Connect to the pod

`kubectl -n indexer exec --stdin --tty kafka-0 -- /bin/bash`

- Create a topic

- `kafka-topics.sh --create --topic cross-yield-events-56 --bootstrap-server localhost:9092`
- `kafka-topics.sh --create --topic cross-yield-events-43114 --bootstrap-server localhost:9092`

- Verify the topic was created

`kafka-topics.sh --list --bootstrap-server localhost:9092`

- Run helm install

- `helm install cross-yield-connector-56 --set nameOverride="bsc" helm/cross-yield-connector`
- `helm install cross-yield-consumer-56 --set nameOverride="bsc" helm/cross-yield-consumer`

- `helm install cross-yield-connector-43114 --set nameOverride="avax" helm/cross-yield-connector`
- `helm install cross-yield-consumer-43114 --set nameOverride="avax" helm/cross-yield-consumer`
