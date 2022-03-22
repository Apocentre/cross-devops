# Instructions

For each project, first run the commands on the project's repository and then the commands in this (devops) repository.

## In each project's repository

1. Merge latest develop into main and push the main branch
2. Run the correct command from the list below to build and push the docker image; add your github token in the `GITHUB_TOKEN` field
3. Push the image that has been created

    e.g. `registry.digitalocean.com/hotcross/hotcross-app:2.43.0`

4. Create and push the tag for the newly built version, e.g `v2.43.0`. 

    Tags can be custom named for certain projects, you can check the tags list for the naming scheme by running `git tag`

## In this (devops) repository

Before deploying a service make sure that you set the secrets.

In each service there is a `secrets.example.yaml` file. You will have to copy this and rename it to `secrets.prod.yaml`. Also, you would have to add the missing values. Never commit any changes to the `secrets.example.yaml` file, the `secrets.prod.yaml` is git-ignored by default.

1. Update the `tag` field in the project chart's `values.yaml` file with the correct version for each docker image
2. Upgrade deployment on K8s

    `helm upgrade cross-api helm/cross-api`

3. Verify the deployment was successful (replace `-n api` with the appropriate namespace)

    `kubectl -n api get pods`: this will return the list of pods. If run immediately after deployment you should see a list of pods as __Terminating__ and some as __ContainerCreating__. As long as no error shows there, the old pods disappear and the new pods show as __Running__, the deployment went ok.

    `kucectl -n api describe pods <pod>`: Get information about the pods deployment. Use this command if something is wrong with the deplotment

    `kucectl -n api logs <pod>`: Get the logs of the instance.

The list of services we use are:

- `helm upgrade hotcross-app helm/hotcross-app`
- `helm upgrade cross-api helm/cross-api`
- `helm upgrade cross-mint helm/cross-mint`
- `helm upgrade cross-send helm/cross-send`
- ...

Hotcross App
===

```
 docker build \
 --build-arg GITHUB_TOKEN= \
 -t registry.digitalocean.com/hotcross/hotcross-app:2.43.0 \
 -f ./operations/cross-pool/Dockerfile .
```

Cross Pool Cache
===

```
 docker build \
 --build-arg GITHUB_TOKEN= \
 -t registry.digitalocean.com/hotcross/cross-pool-cache:2.2.0 \
 -f ./operations/Dockerfile .
```

Cross Api
===

```
 docker build \
 --build-arg GITHUB_TOKEN= \
 -t registry.digitalocean.com/hotcross/cross-api:3.12.0 \
 -f ./operations/Dockerfile .
```

Bridge dApp
===

```
 docker build \
 --build-arg GITHUB_TOKEN= \
 -t registry.digitalocean.com/hotcross/dapp:2.1.2.hotcross \
 -f ./operations/dapp/Dockerfile .
```

Bridge Validator
===

```
 docker build \
 --build-arg GITHUB_TOKEN= \
 -t registry.digitalocean.com/hotcross/validator:1.5.5 \
 -f ./operations/validator/Dockerfile .
```

Cross Mint
===

```
 docker build \
 --build-arg GITHUB_TOKEN= \
 -t registry.digitalocean.com/hotcross/cross-mint:1.9.0 \
 -f ./operations/cross-mint/Dockerfile .
```

Cross Mint Api
===

```
 docker build \
 --build-arg GITHUB_TOKEN= \
 -t registry.digitalocean.com/hotcross/cross-mint-api:1.0.1 \
 -f ./operations/api/Dockerfile .
```

Cross Vest Investor
===

```
 docker build \
 --build-arg GITHUB_TOKEN= \
 -t registry.digitalocean.com/hotcross/cross-vest:investor-1.3.1 \
 -f ./operations/dapp/investor.Dockerfile .
```

Cross Vest Admin
===

```
 docker build \
 --build-arg GITHUB_TOKEN= \
 -t registry.digitalocean.com/hotcross/cross-vest:admin-1.3.1 \
 -f ./operations/dapp/admin.Dockerfile .
```

Cross Pool Connector
===

```
 docker build \
 -t registry.digitalocean.com/hotcross/cross-pool-connector:0.13.0 \
 -f ./operations/cross-pool-connector/Dockerfile src/rust
```

Cross Pool Consumer
===

```
 docker build \
 -t registry.digitalocean.com/hotcross/cross-pool-consumer:0.7.0 \
 -f ./operations/cross-pool-consumer/Dockerfile src/rust
```

Cross Pool V2 Connector
===

```
 docker build \
 -t registry.digitalocean.com/hotcross/cross-pool-v2-connector:0.1.0 \
 -f ./operations/cross-pool-v2-connector/Dockerfile src/rust
```

Cross Pool V2 Consumer
===

```
 docker build \
 -t registry.digitalocean.com/hotcross/cross-pool-v2-consumer:0.1.0 \
 -f ./operations/cross-pool-v2-consumer/Dockerfile src/rust
```

Cross Mint Connector
===

```
 docker build \
 -t registry.digitalocean.com/hotcross/cross-mint-connector:0.3.0 \
 -f ./operations/cross-mint-connector/Dockerfile src/rust
```

Cross Mint Consumer
===

```
 docker build \
 -t registry.digitalocean.com/hotcross/cross-mint-consumer:0.3.0 \
 -f ./operations/cross-mint-consumer/Dockerfile src/rust
```

Cross KYC Connector
===

```
 docker build \
 -t registry.digitalocean.com/hotcross/cross-kyc-connector:0.2.0 \
 -f ./operations/cross-kyc-connector/Dockerfile src/rust
```

Cross KYC Consumer
===

```
 docker build \
 -t registry.digitalocean.com/hotcross/cross-kyc-consumer:0.2.0 \
 -f ./operations/cross-kyc-consumer/Dockerfile src/rust
```

Analytics API
===

```
 docker build \
 -t registry.digitalocean.com/hotcross/analytics-api:0.13.0 \
 -f ./operations/analytics-api/Dockerfile src/rust
```

Price Feed
===

```
 docker build \
 -t registry.digitalocean.com/hotcross/price-feed:0.13.2 \
 -f ./operations/price-feed/Dockerfile src/rust
```

APR Feed
===

```
 docker build \
 -t registry.digitalocean.com/hotcross/apr-feed:0.4.0 \
 -f ./operations/apr-feed/Dockerfile src/rust
```

DEX Data Feed
===

```
 docker build \
 -t registry.digitalocean.com/hotcross/dex-data-feed:0.1.2 \
 -f ./operations/dex-data-feed/Dockerfile src/rust
```

KYC Status Checker
===

```
 docker build \
 -t registry.digitalocean.com/hotcross/kyc-status-checker:0.1.1 \
 -f ./operations/kyc-status-checker/Dockerfile src/rust
```

Neo4j Backup
===

```
 docker build \
 -t registry.digitalocean.com/hotcross/neo4j-backup:4.2.7 \
 -f ./docker/neo4j-backup/Dockerfile ./docker/neo4j-backup
```

Cross Send dApp
===

```
 docker build \
 --build-arg GITHUB_TOKEN= \
 -t registry.digitalocean.com/hotcross/cross-send:1.6.0 \
 -f ./operations/cross-send/Dockerfile .
```

Cross Yield Connector
===

```
 docker build \
 -t registry.digitalocean.com/hotcross/cross-yield-connector:0.1.0 \
 -f ./operations/cross-yield-connector/Dockerfile src/rust
```

Cross Yield Consumer
===

```
 docker build \
 -t registry.digitalocean.com/hotcross/cross-yield-consumer:0.1.1 \
 -f ./operations/cross-yield-consumer/Dockerfile src/rust
```

Cross Vest Connector
===

```
 docker build \
 -t registry.digitalocean.com/hotcross/cross-vest-connector:0.1.0 \
 -f ./operations/cross-vest-connector/Dockerfile src/rust
```

Cross Vest Consumer
===

```
 docker build \
 -t registry.digitalocean.com/hotcross/cross-vest-consumer:0.1.0 \
 -f ./operations/cross-vest-consumer/Dockerfile src/rust
```

NFT Staking Connector
===

```
 docker build \
 -t registry.digitalocean.com/hotcross/nft-staking-connector:0.1.0 \
 -f ./operations/nft-staking-connector/Dockerfile src/rust
```

NFT Staking Consumer
===

```
 docker build \
 -t registry.digitalocean.com/hotcross/nft-staking-consumer:0.1.0 \
 -f ./operations/nft-staking-consumer/Dockerfile src/rust
```
