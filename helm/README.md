Deploy Redis
===
```
// the password used below is for the staging environment
helm install redis bitnami/redis \
  --namespace storage \
  --set password=Lma5LVU8lMcDRAFwKMLmcUuiIQ+uXaEZIm2eahgr \
  --set cluster.enabled=false \
  --set replica.persistence.size=0.5Gi
```
