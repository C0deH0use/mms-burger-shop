apiVersion: postgresql.cnpg.io/v1
kind: Cluster
metadata:
  name: requests-db
  namespace: burger-shop
spec:
  instances: 1
  storage:
    size: 10Gi
  bootstrap:
    initdb:
      database: requests_db
      owner: postgres
  superuserSecret:
    name: postgres-credentials
    key: requests-db-password
  postgresql:
    parameters:
      max_connections: "100"
  resources:
    requests:
      memory: "1Gi"
      cpu: "500m"
    limits:
      memory: "2Gi"
      cpu: "1000m"