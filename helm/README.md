Deploy Redis
===
```
helm install redis bitnami/redis \
  --namespace storage \
  --set password=3ziOIfyQXfcHo6VcOTflFwzkp05VnHou \
  --set cluster.enabled=false
```
