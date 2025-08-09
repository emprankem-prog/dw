#!/bin/bash

# Define target directory
TARGET_DIR="ComfyUI/models/loras"

# Create directory if it doesn't exist
mkdir -p "$TARGET_DIR"

# Navigate to the directory
cd "$TARGET_DIR" || exit

# Download files
wget -O nipplediffusion-f1.safetensors "https://huggingface.co/uncthethird2/nipple_diffusion/resolve/main/nipplediffusion-f1.safetensors?download=true"
wget -O JD3s_Nudify_Kontext.safetensors "https://huggingface.co/JD3GEN/JD3_Nudify_Kontext_LoRa/resolve/main/JD3s_Nudify_Kontext.safetensors?download=true"
