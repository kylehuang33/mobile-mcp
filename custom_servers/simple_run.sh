#!/bin/bash

# Check if ADB port argument is provided
if [ -z "$1" ]; then
  echo "Usage: ./run.sh <ADB_PORT>"
  exit 1
fi

ADB_PORT=$1

# Step 1: Connect to the ADB device on specified port
adb connect localhost:$ADB_PORT

# # Step 2: Navigate to the project directory
# cd /path/to/your/folder || exit 1

# Step 3: Run the Node.js script with a fixed port 6001
uv run python3 python_simple_mcp_server.py
