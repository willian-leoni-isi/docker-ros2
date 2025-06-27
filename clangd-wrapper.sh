#!/bin/bash
CONTAINER_WORKSPACE_DIR="/ros_humble" # Ajuste se necessário
docker exec -i -w "$CONTAINER_WORKSPACE_DIR" ros2_humble clangd "$@"
