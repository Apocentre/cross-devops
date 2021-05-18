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

Integrate DO Docker Registry with k8s
===
https://docs.digitalocean.com/products/container-registry/how-to/use-registry-docker-kubernetes/

We need to then use the following value in all of our Helm charts

```
imagePullSecrets:
  - name: "hotcross" // or "hotcross-staging" for staging env
```


Setting up Nginx Ingress Controller
===

1. Install the ingress

`kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.46.0/deploy/static/provider/do/deploy.yaml`

https://kubernetes.github.io/ingress-nginx/deploy/#digital-ocean


2. Verify that it's been installed

`kubectl get pods -n ingress-nginx -l app.kubernetes.io/name=ingress-nginx --watch`

Check that load balancer service is running 
`kubectl get svc --namespace=ingress-nginx`

Install cert-manager to handle the ssl certificates for the ingress
===

  - `kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.3.1/cert-manager.yaml`

  NOTE: If the above command fails try installing it using Helm

  1. `kubectl create namespace cert-manager`
  2. `helm repo add jetstack https://charts.jetstack.io`
  3. `helm repo update`
  4. `kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.3.1/cert-manager.crds.yaml`
  5. and finally

  ```
  helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.3.1
  ```

  - Verify the installation
  `kubectl get pods --namespace cert-manager`

  - Create let's encrypt issuer
  `kubectl apply -f kubectl/common/cert-issuer.yaml`

More info here:
- https://cert-manager.io/docs/installation/kubernetes/
- https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nginx-ingress-on-digitalocean-kubernetes-using-helm
- https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nginx-ingress-with-cert-manager-on-digitalocean-kubernetes

2. A very important step to make the cert-manager issue certificates is this 

- https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nginx-ingress-with-cert-manager-on-digitalocean-kubernetes#step-5-%E2%80%94-enabling-pod-communication-through-the-load-balancer-optional
- https://github.com/digitalocean/digitalocean-cloud-controller-manager/blob/master/docs/controllers/services/examples/README.md#accessing-pods-over-a-managed-load-balancer-from-inside-the-cluster

Basically:

i) Create a new DNS record on DO balancer.hotcross.com (or balancer.hotcross.com if on staging) pointing to the Load Balancer
ii) Run `kubectl apply -f kubectl/<environment>/lb/ingress-nginx-svc.yaml`


3. Add a new subdomain and point it to the LB created by DO when initializing the K8s cluster. We need one subdomain per service that we want to be publicly accessible through the Ingress. 

To check the status of the certificates after a deployment (see steps below) is running we can run the following command:

`kubectl describe certificate hotcross-tls -n api` 

You can run this for any namespace (-n) on which we have deployed an ingress


Common Tasks
===
1. Create custom namespaces

`kubectl apply -f kubectl/common/ns.yaml`

2. Create Ingresses

`kubectl apply -f kubectl/<environment>/ingress/`

Deploy Services
===

1. Cross Api

`helm install cross-api helm/cross-api`

When we update some of the values of the chart we can then upgrade by running:

`helm upgrade cross-api helm/cross-api`

Open K8s dashboard
===

Go to the cluster page on DO 

https://cloud.digitalocean.com/kubernetes/clusters/ 

and click the Kubernetes Dashboard button

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

Notes
===
- A very useful tutorial on setting up Cert Manager is

https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nginx-ingress-with-cert-manager-on-digitalocean-kubernetes

Troubleshooting
===

1. Cert manager 

https://stackoverflow.com/questions/64624877/cert-manager-certificate-creation-stuck-at-created-new-certificaterequest-resour/65809340#65809340
