#!/bin/bash
#
# // BLADE PROTOCOL: LAUNCH_SGLANG_v1.0
# // Ignites the sglang inference server with the DAG-Reasoning model.
#

MODEL_PATH="/workspace/models/<change-your-model-here>"
LOG_FILE="/workspace/<your>-engine/sglang_server.log"
PORT=7501

echo "--- Igniting sglang Inference Engine ---"
echo "Model: $MODEL_PATH"
echo "Port: $PORT"
echo "Log File: $LOG_FILE"

# Activate the virtual environment
source /workspace/<your>-engine/.venv/bin/activate

# Launch the server in the background using nohup
nohup python3 -m sglang.launch_server \
    --model-path "$MODEL_PATH" \
    --port "$PORT" \
    --host 0.0.0.0 \
    > "$LOG_FILE" 2>&1 &

echo "✅ Server process launched in background. PID: $!"
echo "Monitor startup with: tail -f $LOG_FILE"
