apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

namespace: burger-shop

resources:
  - operator.yaml
  - requests-db.yaml
  - shelf-db.yaml
  - postgres-secret.yaml
