# my-konnect

My Kong Konnect playground

## Steps

* You need a Kubernetes cluster and configured `kubectl`. See the included `eks` submodule that will provision an EKS cluster and help you configure `kubectl`.

## Bitnami sealed secrets

This repo uses [bitnami sealed secrets](https://github.com/bitnami-labs/sealed-secrets) to allow managing secrets in git like other resources

* Install kubeseal to work with secrets (assumes arm64, adjust as necessary)
```
make install-kubeseal
```

* Install Bitnami sealed secrets controller
```
make install-bitnami-secret-controller
```

* Grab the secret controller public key, used to seal secrets
```
make get-bitnami-secret-controller-public-key
```

## Add Runtime Instance to Konnect

* Until the public API for Konnect is available, add a Runtime Instance manually following the Konnect UI prompts

* Add the cluster cert and key as a secret in Kubernetes using sealed secrets:

```
kubectl create secret tls kong-cluster-cert -n kong --cert=<cert-path> --key=<key-path> --dry-run=client -o yaml > secrets/local-toseal/kong-cluster-cert.yaml
```

* Seal the secret

```
./scripts/seal-secrets.sh
```

* Apply the sealed secret to the cluster. This will be materialized into a K8s secret by the sealed secret controller. (Note: this is useful at some point when we have something like GitOps in place and the sealed secret is pushed to git and then onto K8s automatically).

```
kubectl apply -f secrets/sealed/kong-cluster-cert.yaml
```

* Save the configuration values in the Konnect UI to `values.yaml`

* Install Kong

```
helm install my-kong kong/kong -n kong --values ./values.yaml
```

