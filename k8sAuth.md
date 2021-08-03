Authentication
===

We need to allow devs to access the k8s cluster.

Follow this guide:

https://www.digitalocean.com/community/tutorials/recommended-steps-to-secure-a-digitalocean-kubernetes-cluster

1. Generate a new private key for the user

`openssl genrsa -out ./certs/pavlos/pavlos.key 4096`

2. Create a certificate signing request configuration file

`nano ./certs/pavlos/pavlos.csr.cnf` 

and add the following content

```
[ req ]
default_bits = 2048
prompt = no
default_md = sha256
distinguished_name = dn
[ dn ]
CN = pavlos
O = developers
[ v3_ext ]
authorityKeyIdentifier=keyid,issuer:always
basicConstraints=CA:FALSE
keyUsage=keyEncipherment,dataEncipherment
extendedKeyUsage=serverAuth,clientAuth
```

3. Create Certificate Signing request

`openssl req -config ./certs/pavlos/pavlos.csr.cnf -new -key ./certs/pavlos/pavlos.key -nodes -out ./certs/pavlos/pavlos.csr`

4. Send a CSR to the DOKS cluster use the following command:

```
cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1beta1
kind: CertificateSigningRequest
metadata:
  name: pavlos-authentication
spec:
  groups:
  - system:authenticated
  request: $(cat ./certs/pavlos/pavlos.csr | base64 | tr -d '\n')
  usages:
  - digital signature
  - key encipherment
  - server auth
  - client auth
EOF
```

5. Approve the certificate request we just pushed to DOKS

`kubectl certificate approve pavlos-authentication`

You can verify that it has been approved

`kubectl get csr`

6. Now that the CSR is approved, you can download it to the local machine by running:

```
kubectl get csr pavlos-authentication -o jsonpath='{.status.certificate}' | base64 --decode > ./certs/pavlos/pavlos.crt
```


Create Kube config
===

With the pavlos signed certificate in hand, you can now build the user’s kubeconfig file.

1. Create a copy of the local kube/config

`cp misc/config/k8s/config ./certs/pavlos/config-pavlos`

And change the user props to resemble the following file:

```
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: certificate_data
  name: do-nyc1-do-cluster
contexts:
- context:
    cluster: do-nyc1-do-cluster
    user: pavlos
  name: do-nyc1-do-cluster
current-context: do-nyc1-do-cluster
kind: Config
preferences: {}
users:
- name: pavlos
  user:
    client-certificate: <absolute_path_to_certs_folder>/pavlos.crt
    client-key: <absolute_path_to_certs_folder>/pavlos.key
```

2. You can test the new user connection using kubectl cluster-info:

```
kubectl --kubeconfig=./certs/pavlos/config-pavlos cluster-info
```

You should see something like this:

```
To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
Error from server (Forbidden): services is forbidden: User "pavlos" cannot list resource "services" in API group "" in the namespace "kube-system"
```

This error is expected because the user pavlos has no authorization to list any resource on the cluster yet.

Granting Permissions
===

1. Assign edit permissions to the user pavlos in all namespace using the following commands:

```
kubectl create rolebinding pavlos-edit-role --clusterrole=edit --user=pavlos --namespace=default
kubectl create rolebinding pavlos-edit-role --clusterrole=edit --user=pavlos --namespace=api
kubectl create rolebinding pavlos-edit-role --clusterrole=edit --user=pavlos --namespace=crosspool
kubectl create rolebinding pavlos-edit-role --clusterrole=edit --user=pavlos --namespace=microservices
kubectl create rolebinding pavlos-edit-role --clusterrole=edit --user=pavlos --namespace=storage
kubectl create rolebinding pavlos-edit-role --clusterrole=edit --user=pavlos --namespace=indexer
kubectl create rolebinding pavlos-edit-role --clusterrole=edit --user=pavlos --namespace=mint-indexer

and any other ns we add in the future
```

2. Next, verify user permissions by listing pods in the default namespace. 

```
kubectl --kubeconfig=./certs/pavlos/config-pavlos auth can-i get pods -n api
kubectl --kubeconfig=./certs/pavlos/config-pavlos auth can-i get pods -n crosspool

and any other ns we add in the future
```
