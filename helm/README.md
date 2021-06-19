Deploy Redis
===
```
// the password used below is for the staging environment
// https://github.com/bitnami/charts/tree/master/bitnami/redis
helm install redis bitnami/redis \
  --namespace storage \
  --set auth.password=Lma5LVU8lMcDRAFwKMLmcUuiIQ+uXaEZIm2eahgr \
  --set cluster.enabled=false \
  --set master.persistence.size=1Gi \
  --set replica.persistence.size=1Gi
```


Deploy Indexer Services
===
1. Redis (same as earlier)

// the password used below is for the staging environment
```bash
helm install redis bitnami/redis \
  -n indexer \
  --set auth.password=Lma5LVU8lMcDRAFwKMLmcUuiIQ+uXaEZIm2eahgr \
  --set cluster.enabled=false \
  --set replica.replicaCount=1 \
  --set master.persistence.size=10Gi \
  --set replica.persistence.size=10Gi
```

To expose it via ingress follow this tutorial https://minikube.sigs.k8s.io/docs/tutorials/nginx_tcp_udp_ingress/


2. Kafka

  ```bash
    helm install kafka bitnami/kafka \
    -n indexer \
    --set zookeeper.enabled=true \
    --set replicaCount=1 \
    --set deleteTopicEnable=true \
    --set autoCreateTopicsEnable=true \
    --set persistence.size=100Gi
  ```

  Kafka is available:
  - at `kafka.indexer.svc.cluster.local:9092` for consumers
  - at `kafka-0.kafka-headless.indexer.svc.cluster.local:9092` for producers,

3. Deploy Neo4j

  // the password used below is for the staging environment
  ```bash
  helm install neo4j helm/neo4j \
  -n indexer \
  --set core.standalone=true \
  --set acceptLicenseAgreement=yes \
  --set neo4jPassword=klC/ddwf0hok1xuilAgBWkhGbR7/gOqifnkWC+Ga \
  --set core.persistentVolume.size=50Gi
  ```

  Neo4JS is available:
    - at `neo4j.indexer.svs.cluster.local:7687`
