# devops

Login to Github registry
===

You must use a personal access token with the appropriate scopes to publish and install packages in GitHub Packages.

`$ cat ~/TOKEN.txt | docker login https://docker.pkg.github.com -u USERNAME --password-stdin`

https://docs.github.com/en/packages/guides/configuring-docker-for-use-with-github-packages

Get The GEOIP database
===
https://www.maxmind.com/en/accounts/534933/geoip/downloads


#k8s Cluster
===

1. Connect to the cluster

https://docs.digitalocean.com/products/kubernetes/how-to/connect-to-cluster/

2. Setup the k8s dashboard

https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/

3. Start the proxy

`kubectl proxy`

4. Open the dashboard

`http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/`

- Use token to login
  - Find the name of the secret

  `kubectl -n kubernetes-dashboard get secrets`

  - get the token from the secret

  `kubectl -n kubernetes-dashboard  describe secret kubernetes-dashboard-token-j7hpq`

5. Install cert-manager to handle the ssl certificates for the ingress

  - `kubectl create namespace cert-manager`
  - `helm repo add jetstack https://charts.jetstack.io`
  - `helm repo update`
  - `kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.3.0/cert-manager.crds.yaml`
  - Install the chart

  ```
  helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --version v1.3.0 \
  //--set installCRDs=true
  ```


https://cert-manager.io/docs/installation/kubernetes/
https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nginx-ingress-on-digitalocean-kubernetes-using-helm
