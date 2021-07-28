# Deploy Indexer Services

In the first iteration we will use the same Redis and Kafka instances as the ones used in the cross pool indexer. However, we will create a separate neo4j. In the future we will use a single database; For that to happen we would simply need to restart the consumer from offset 0 and point it to the neo4j we want.

1. Create Kafka topics

**Run command line**

- Connect to the pod

`kubectl -n indexer exec --stdin --tty kafka-0 -- /bin/bash`

- Create a topic

`kafka-topics.sh --create --topic cross-mint-events-1 --bootstrap-server localhost:9092`
`kafka-topics.sh --create --topic cross-mint-events-56 --bootstrap-server localhost:9092`
`kafka-topics.sh --create --topic cross-mint-events-137 --bootstrap-server localhost:9092`

- Verify the topic was created

`kafka-topics.sh --describe --topic cross-mint-events-1  --bootstrap-server localhost:9092`
`kafka-topics.sh --describe --topic cross-mint-events-56  --bootstrap-server localhost:9092`
`kafka-topics.sh --describe --topic cross-mint-events-137  --bootstrap-server localhost:9092`

or

`kafka-topics.sh --list --bootstrap-server localhost:9092`

2. Deploy Neo4j

// the password used below is for the staging environment

```bash
helm install neo4j helm/neo4j \
-n indexer \
--set core.standalone=true \
--set acceptLicenseAgreement=yes \
--set neo4jPassword=QaxuCddD5Q3h6fPd6cZ8DEvSGEc4SWGT2uBZ \
--set core.persistentVolume.size=25Gi
```

3. Run helm install

i) Three instances of the cross-mint-connector running on each network each

`helm install cross-mint-connector-1 --set nameOverride="eth" helm/cross-mint-connector`
`helm install cross-mint-connector-56 --set nameOverride="bsc" helm/cross-mint-connector`
`helm install cross-mint-connector-137 --set nameOverride="polygon" helm/cross-mint-connector`

ii) One instance of the cross-mint-consumer

`helm install cross-mint-consumer-1  --set nameOverride="eth" helm/cross-mint-consumer`
`helm install cross-mint-consumer-56  --set nameOverride="bsc" helm/cross-mint-consumer`
`helm install cross-mint-consumer-137  --set nameOverride="polygon" helm/cross-mint-consumer`
