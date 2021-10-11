
1. Create Kafka topics

**Run command line**

`kubectl -n indexer exec --stdin --tty kafka-0 -- /bin/bash`

- Create a topic

- `kafka-topics.sh --create --topic cross-kyc-events-56 --bootstrap-server localhost:9092`

- Verify the topic was created

- `kafka-topics.sh --describe --topic cross-kyc-events-56 --bootstrap-server localhost:9092`

or

`kafka-topics.sh --list --bootstrap-server localhost:9092`

2. Run helm install

- `helm install cross-kyc-connector-56 --set nameOverride="bsc" helm/cross-kyc-connector`
- `helm install cross-kyc-consumer-56 --set nameOverride="bsc" helm/cross-kyc-consumer`
