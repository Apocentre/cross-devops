# Deploy Redis

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



**Choose Values for Cross Vest**

- Admin

`helm install cross-vest-admin helm/cross-vest -f helm/cross-vest/values-admin.yaml`

- Investor

`helm install cross-vest-investor helm/cross-vest -f helm/cross-vest/values-investor.yaml`
