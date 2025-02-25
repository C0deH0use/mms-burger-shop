# kafka-config.yaml
apiVersion: kafka.strimzi.io/v1beta2
kind: Kafka
metadata:
  name: burger-shop-kafka
  namespace: burger-shop
spec:
  kafka:
    version: 3.5.0
    replicas: 2
    listeners:
      - name: plain
        port: 9092
        type: internal
        tls: false
      - name: external
        port: 9093
        type: nodeport
        tls: false
    config:
      offsets.topic.replication.factor: 2
      transaction.state.log.replication.factor: 2
      transaction.state.log.min.isr: 1
      default.replication.factor: 2
      min.insync.replicas: 1
      inter.broker.protocol.version: "3.5"
    storage:
      type: jbod
      volumes:
        - id: 0
          type: persistent-claim
          size: 100Gi
          deleteClaim: false
    resources:
      requests:
        memory: 2Gi
        cpu: "1"
      limits:
        memory: 4Gi
        cpu: "2"
  zookeeper:
    replicas: 3
    storage:
      type: persistent-claim
      size: 10Gi
      deleteClaim: false
    resources:
      requests:
        memory: 1Gi
        cpu: "500m"
      limits:
        memory: 2Gi
        cpu: "1"
---
# schema-registry.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: schema-registry
  namespace: burger-shop
spec:
  replicas: 1
  selector:
    matchLabels:
      app: schema-registry
  template:
    metadata:
      labels:
        app: schema-registry
    spec:
      containers:
        - name: schema-registry
          image: confluentinc/cp-schema-registry:7.8.0
          ports:
            - containerPort: 8081
          env:
            - name: SCHEMA_REGISTRY_HOST_NAME
              value: schema-registry
            - name: SCHEMA_REGISTRY_KAFKASTORE_BOOTSTRAP_SERVERS
              value: burger-shop-kafka-kafka-0.burger-shop-kafka-kafka-brokers.burger-shop.svc:9092,burger-shop-kafka-kafka-1.burger-shop-kafka-kafka-brokers.burger-shop.svc:9092
            - name: SCHEMA_REGISTRY_LISTENERS
              value: http://0.0.0.0:8081
          resources:
            requests:
              memory: "512Mi"
              cpu: "250m"
            limits:
              memory: "1Gi"
              cpu: "500m"
---
# control-center.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: control-center
  namespace: burger-shop
spec:
  replicas: 1
  selector:
    matchLabels:
      app: control-center
  template:
    metadata:
      labels:
        app: control-center
    spec:
      containers:
        - name: control-center
          image: confluentinc/cp-enterprise-control-center:7.8.0
          ports:
            - containerPort: 9021
          env:
            - name: CONTROL_CENTER_BOOTSTRAP_SERVERS
              value: burger-shop-kafka-kafka-0.burger-shop-kafka-kafka-brokers.burger-shop.svc:9092,burger-shop-kafka-kafka-1.burger-shop-kafka-kafka-brokers.burger-shop.svc:9092
            - name: CONTROL_CENTER_SCHEMA_REGISTRY_URL
              value: http://schema-registry:8081
            - name: CONTROL_CENTER_REPLICATION_FACTOR
              value: "2"
            - name: CONTROL_CENTER_INTERNAL_TOPICS_PARTITIONS
              value: "2"
            - name: CONTROL_CENTER_MONITORING_INTERCEPTOR_TOPIC_PARTITIONS
              value: "2"
            - name: CONFLUENT_METRICS_TOPIC_REPLICATION
              value: "2"
          resources:
            requests:
              memory: "2Gi"
              cpu: "1"
            limits:
              memory: "4Gi"
              cpu: "2"
---
# services.yaml
apiVersion: v1
kind: Service
metadata:
  name: schema-registry
  namespace: burger-shop
spec:
  selector:
    app: schema-registry
  ports:
    - port: 8081
      targetPort: 8081
---
apiVersion: v1
kind: Service
metadata:
  name: control-center
  namespace: burger-shop
spec:
  selector:
    app: control-center
  ports:
    - port: 9021
      targetPort: 9021