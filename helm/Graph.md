1. Install Postgress


```
helm repo add bitnami https://charts.bitnami.com/bitnami

helm install postgres bitnami/postgresql \
  --namespace bttc \
  --set global.postgresql.auth.username=user \
  --set global.postgresql.auth.password=e57mPmJ7DoE47zRoG7fMEYNpf7ryssXtUdKLzh0 \
  --set global.postgresql.auth.database=graph \
  --set primary.persistence.size=1Gi 
```

Check that the graph db was created:

- `kubectl -n bttc exec  --stdin --tty postgres-postgresql-0  -- /bin/bash`
- `psql -U user -d graph -W`

If success then the database exists


2. Install Graph

```
helm install graph-node-1029 --set nameOverride="bttc" helm/graph-node
```
