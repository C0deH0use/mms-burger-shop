# Burger Shop Project

This project simulates a burger shop operation with two main components: kitchen-worker and restaurant-requests.

## Project Structure

```mermaid
graph TD
    A[Burger Shop Project] --> B[kitchen-worker]
    A --> C[restaurant-requests]
    B --> D[Processes orders]
    B --> E[Manages inventory]
    C --> F[Handles customer orders]
    C --> G[Manages order queue]
```

## Components

1. **kitchen-worker**: This component is responsible for:
   - Processing incoming orders
   - Managing the kitchen inventory
   - Preparing burgers and other menu items

2. **restaurant-requests**: This component handles:
   - Receiving customer orders
   - Managing the order queue
   - Communicating with the kitchen-worker

## Getting Started

[Add instructions on how to set up and run the project]


## 

```mermaid
sequenceDiagram
participant RequestService as Request Service
participant Cache as Redis (Shelf State)
participant Kafka as Kafka (Event Bus)
participant KitchenWorkers as Kitchen Workers

RequestService->>Cache: Check shelf for item availability
alt Item available
RequestService->>Cache: Reserve items for order
RequestService->>Kafka: Notify shelf update via ShelfEventsTopic
else Item missing
RequestService->>Kafka: Publish missing items on MissingItemsTopic
end

Kafka->>KitchenWorkers: Consume missing item request
KitchenWorkers->>KitchenWorkers: Prepare items
KitchenWorkers->>Cache: Add items to shelf
KitchenWorkers->>Kafka: Publish shelf update via ShelfEventsTopic

Kafka->>RequestService: Notify shelf update


```

## Contributing

[Add guidelines for contributing to the project]

## License

[Specify the license under which this project is released]
