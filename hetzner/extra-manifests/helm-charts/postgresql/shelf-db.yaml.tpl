apiVersion: postgresql.cnpg.io/v1
kind: Cluster
metadata:
  name: shelf-db
  namespace: burger-shop
spec:
  instances: 1
  storage:
    size: 10Gi
  bootstrap:
    initdb:
      database: shelf_db
      owner: postgres
  superuserSecret:
    name: postgres-credentials
    key: shelf-db-password
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