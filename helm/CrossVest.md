**Choose Values for Cross Vest**

- Admin

`helm install cross-vest-admin helm/cross-vest -f helm/cross-vest/values-admin.yaml`

- Investor

`helm install cross-vest-investor helm/cross-vest -f helm/cross-vest/values-investor.yaml`

- Connect to the pod

`kubectl -n indexer exec --stdin --tty kafka-0 -- /bin/bash`

- Create a topic

- `kafka-topics.sh --create --topic cross-vest-events-56 --bootstrap-server localhost:9092`
- `kafka-topics.sh --create --topic cross-vest-events-42 --bootstrap-server localhost:9092`
- `kafka-topics.sh --create --topic cross-vest-events-137 --bootstrap-server localhost:9092`

- Verify the topic was created

`kafka-topics.sh --list --bootstrap-server localhost:9092`

- Run helm install for the indexer

- `helm install cross-vest-connector-56 --set nameOverride="bsc" helm/cross-vest-connector`
- `helm install cross-vest-consumer-56 --set nameOverride="bsc" helm/cross-vest-consumer`

- `helm install cross-vest-connector-42 --set nameOverride="eth" helm/cross-vest-connector`
- `helm install cross-vest-consumer-42 --set nameOverride="eth" helm/cross-vest-consumer`

- `helm install cross-vest-connector-137 --set nameOverride="polygon" helm/cross-vest-connector`
- `helm install cross-vest-consumer-137 --set nameOverride="polygon" helm/cross-vest-consumer`