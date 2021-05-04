# devops

Create Cluster
===

This is via the Digital Ocean Dashboard. 

1. Click Kubernetes on the side menu
2. Click Create Cluster button
3. Follow the steps on the UI wizzard
4. Create a local k8s config to connect to the cluster

For example

`doctl kubernetes cluster kubeconfig save 52cabdf0-d413-47df-a34f-c6bffb749cd4`

The last part will be different for each cluster; 

More on that here https://docs.digitalocean.com/products/kubernetes/how-to/connect-to-cluster/

Setting up Nginx Ingress Controller
===
1. Add a new subdomain and point it to the LB created by DO when initializing the K8s cluster
  We need on subdomain per service that we want to be publicly accessible through the Ingress

2. A very important step to make the cert-manager issue certificates is this 

https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nginx-ingress-with-cert-manager-on-digitalocean-kubernetes#step-5-%E2%80%94-enabling-pod-communication-through-the-load-balancer-optional

Basically:

i) Create a new DNS record on DO workaround.hotcross.com pointing to the Load Balancer
ii) Run `kubectl apply -f kubectl/common/ingress-nginx-svc.yaml`
  
3. Install the ingress

https://kubernetes.github.io/ingress-nginx/deploy/#digital-ocean

`kubectl get pods -n ingress-nginx \
  -l app.kubernetes.io/name=ingress-nginx --watch`

Install cert-manager to handle the ssl certificates for the ingress
===

  - `kubectl create namespace cert-manager`
  - `helm repo add jetstack https://charts.jetstack.io`
  - `helm repo update`
  - `kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.3.1/cert-manager.crds.yaml`
  - Install the chart

  ```
  helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager\
  --version v1.3.1
  ```

  - Verify the installation
  `kubectl get pods --namespace cert-manager`


  - Create let's encrypt issuer
  `cd kubectl/common && kubectl apply -f cert-issuer.yaml`


More info here:
- https://cert-manager.io/docs/installation/kubernetes/
- https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nginx-ingress-on-digitalocean-kubernetes-using-helm
- https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nginx-ingress-with-cert-manager-on-digitalocean-kubernetes

Integrate DO Docker Registry with k8s
===
https://docs.digitalocean.com/products/container-registry/how-to/use-registry-docker-kubernetes/

https://docs.digitalocean.com/products/container-registry/how-to/use-registry-docker-kubernetes/#create-secret-manually

https://docs.digitalocean.com/products/container-registry/how-to/use-registry-docker-kubernetes/#add-secret-control-panel


Open K8s dashboard
===

Go to the cluster page on DO 

https://cloud.digitalocean.com/kubernetes/clusters/ 

and click the Kubernetes Dashboard button

Deploy Services
===

1. Cross Api

`helm install cross-api helm/cross-api`

Login to Github registry
===

You must use a personal access token with the appropriate scopes to publish and install packages/images in GitHub Packages.

`$ cat ~/TOKEN.txt | docker login https://docker.pkg.github.com -u USERNAME --password-stdin`

https://docs.github.com/en/packages/guides/configuring-docker-for-use-with-github-packages

Get The GEOIP database
===
https://www.maxmind.com/en/accounts/534933/geoip/downloads

**DEPRECATED(This is relevant if we manually create a dashboard)**
Setup the k8s dashboard
===

https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/

Open the dashboard
===

`http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/`

- Use token to login
  - Find the name of the secret

  `kubectl -n kubernetes-dashboard get secrets`

  - get the token from the secret

  `kubectl -n kubernetes-dashboard  describe secret kubernetes-dashboard-token-j7hpq`
