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

```bash
helm install redis bitnami/redis \
  --namespace indexer \
  --set auth.password=Lma5LVU8lMcDRAFwKMLmcUuiIQ+uXaEZIm2eahgr \
  --set cluster.enabled=false \
  --set master.persistence.size=1Gi \
  --set replica.persistence.size=1Gi
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
    --set persistence.size=1Gi
  ```

  Kafka is available:
  - at `kafka.indexer.svc.cluster.local:9092` for consumers
  - at `kafka-0.kafka-headless.indexer.svc.cluster.local:9092` for producers,

