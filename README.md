# devops

Create Cluster
===

This is via the Digital Ocean Dashboard. 

1. Click Kubernetes on the side menu
2. Click Create Cluster button
3. Follow the steps on the UI wizzard
4. Create a local k8s config to connect to the cluster

For example

`doctl kubernetes cluster kubeconfig save aadb9808-3988-4984-8f2c-6f8f490e5c67`

The last part will be different for cluster; the one in the above example points to the production cluster

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


Access Kafka cli Remotely
===

1. Exec the pod

`kubectl -n indexer exec  --stdin --tty kafka-0 -- /bin/bash`

2. Access the cli command 

`cd /opt/bitnami/kafka/bin/`

For example to list all consumer groups

`./kafka-consumer-groups.sh --bootstrap-server localhost:9092 --list`

or to delete a consumer group

`./kafka-consumer-groups.sh --bootstrap-server localhost:9092 --delete --group analytics-api-consumer-group`

or create a topic 

`./kafka-topics.sh --bootstrap-server localhost:9092 --create --topic cross-pool-events`

or list all topics

`./kafka-topics.sh --bootstrap-server localhost:9092 --list`

or delete a topic 

`./kafka-topics.sh --bootstrap-server localhost:9092 --delete --topic cross-pool-events`

check consumer lag

`/opt/bitnami/kafka/bin/kafka-consumer-groups.sh --bootstrap-server localhost:9092 --describe --group cross-pool-consumer-group`

Erase Neo4j
===

`CREATE OR REPLACE DATABASE neo4j`

https://stackoverflow.com/a/62539937/512783

Redis-Cli
===

- Connect to the pod

`kubectl -n indexer exec --stdin --tty redis-master-0 -- /bin/bash`

- Run the command line tool

`redis-cli`

- Authenticate

`auth`

- delete keys matching a pattern

`redis-cli -a <password> --scan --pattern reward.pool:* | xargs redis-cli -a <password> del`

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


Nginx Http Basic Auth
===

https://www.digitalocean.com/community/tutorials/how-to-set-up-basic-http-authentication-with-nginx-on-ubuntu-14-04

Notes
===
- A very useful tutorial on setting up Cert Manager is

https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nginx-ingress-with-cert-manager-on-digitalocean-kubernetes

Troubleshooting
===

1. Cert manager 

https://stackoverflow.com/questions/64624877/cert-manager-certificate-creation-stuck-at-created-new-certificaterequest-resour/65809340#65809340

**Multiple ingress**

If we need to use multiple ingress files in the same namespace the we would need to use a different tls secretName.

```
  tls:
  - hosts:
    - crosspool2.hotcross.dev
    secretName: hotcross-tls-2
```

Basically, in order to have multiple ingresses generating multiple certificates is necessary.

2. Automatic Helm Upgrades

This is useful when we want to update an env variable for example but the image tag is still the same.

https://v3.helm.sh/docs/howto/charts_tips_and_tricks/#automatically-roll-deployments

3. Helm Upgrade issue

If you see this error when running helm upgrade

`Error: UPGRADE FAILED: timed out waiting for the condition`

Then you can rollback

`helm rollback`

will rollback to the previous revision.

You can find the revisions here 

`helm history <chart-name>`

4. Identify storage left in a PVC

kubectl -n <namespace> exec <pod-name> df

https://stackoverflow.com/questions/53200828/how-to-identify-the-storage-space-left-in-a-persistent-volume-claim
