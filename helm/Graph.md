1. Install Postgress


```
helm repo add bitnami https://charts.bitnami.com/bitnami

helm install postgres bitnami/postgresql \
  --namespace bttc \
  --set auth.postgresPassword=e57mPmJ7DoE47zRoG7fMEYNpf7ryssXtUdKLzh0 \
  --set auth.database=graph \
  --set primary.persistence.size=100Gi 
```

> NOTE: We need to set the default postgres user password because the Graph node will try to create an extention which only works using the default postgres user. Check for details here https://github.com/bitnami/charts/issues/2830

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.
Check that the graph db was created:

- `kubectl -n bttc exec  --stdin --tty postgres-postgresql-0  -- /bin/bash`
- `psql -U user -d graph -W`

If success then the database exists


2. Install IPFS

```
helm install ipfs helm/ipfs
```

3. Install Graph

```
helm install graph-node-1029 --set nameOverride="bttc" helm/graph-node
```
