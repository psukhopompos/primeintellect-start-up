#!/bin/bash
#
# // BLADE PROTOCOL: PROVISION_FORTRESS_v3.0
# // A definitive, declarative script for a generic CUDA 12 environment.
# // This version is hardened against all previously discovered dependency and build issues.
#

set -e

echo "--- [Phase 1/4] System Preparation ---"
apt-get update
apt-get install -y build-essential git git-lfs python3-pip python3-venv

echo "--- [Phase 2/4] Python Environment & AI Libraries (Hardened) ---"
pip3 install --upgrade pip
pip3 install uv

# Create project directory and virtual environment
mkdir -p /workspace/<your>-engine
cd /workspace/<your>-engine
uv venv
source .venv/bin/activate

# Create the pyproject.toml blueprint with the complete build fix
cat << 'EOT' > pyproject.toml
[project]
name = "<your>-engine"
version = "0.1.0"
requires-python = ">=3.10"
dependencies = [
    "flash-attn",
    "transformers",
    "accelerate",
    "dspy-ai",
    "sentencepiece",
    "protobuf",
    "huggingface-hub",
]

# This is the critical fix. We provide both missing build dependencies to the isolated build environment.
[tool.uv.extra-build-dependencies]
flash-attn = ["setuptools", "torch"]
EOT

# Install torch separately using the correct index URL. This is crucial for the flash-attn build.
echo "Installing PyTorch for CUDA 12.1..."
uv pip install torch --index-url https://download.pytorch.org/whl/cu121

# Install the remaining dependencies. `uv sync` will now correctly build flash-attn.
echo "Syncing remaining dependencies from pyproject.toml..."
uv sync

echo "--- [Phase 3/4] Workspace & Model Acquisition ---"
MODEL_REPO="sequelbox/Qwen3-14B-DAG-Reasoning" # add your model here, format is repos from hugging face
MODEL_DIR="/workspace/models/Qwen3-14B-DAG-Reasoning"

mkdir -p "$MODEL_DIR"

if [ -d "$MODEL_DIR" ] && [ "$(ls -A "$MODEL_DIR")" ]; then
    echo "✅ Model directory '$MODEL_DIR' already exists. Skipping download."
else
    echo "📥 Downloading '$MODEL_REPO' using huggingface-hub..."
    # This method correctly passes shell variables to the inline Python script.
    python3 -c "
from huggingface_hub import snapshot_download
model_repo = '$MODEL_REPO'
local_dir = '$MODEL_DIR'
print(f'Downloading model from {model_repo} to {local_dir}...')
snapshot_download(repo_id=model_repo, local_dir=local_dir, local_dir_use_symlinks=False, resume_download=True)
print('✅ Model download complete.')
"
fi

echo "--- [Phase 4/4] Verification ---"
echo "Verifying environment..."
python3 -c "import torch; import flash_attn; import dspy; print(f'Torch Version: {torch.__version__}'); print(f'CUDA Version via Torch: {torch.version.cuda}'); print('✅ All components imported successfully. Environment is aligned.')"

echo "--- ✅ SUCCESS: Fortress Provisioned. Environment is ready. ---"
echo "Model is located at: $MODEL_DIR"
echo "Your code should go in: /workspace/<your>-engine"
echo "To activate the environment in future sessions, run: source /workspace/<your>-engine/.venv/bin/activate"
