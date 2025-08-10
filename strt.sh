#!/bin/sh
apt update && apt install libgl1-mesa-glx -y && wget https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64/cuda-keyring_1.1-1_all.deb && dpkg -i cuda-keyring_1.1-1_all.deb && apt-get update && apt-get install -y cuda-toolkit-12-4 && rm -rf /var/lib/apt/lists/* && rm cuda-keyring_1.1-1_all.deb && echo "Cloning ComfyUI, ComfyUI-Manager..."
git clone https://github.com/comfyanonymous/ComfyUI.git 
git clone https://github.com/ltdrdata/ComfyUI-Manager.git ComfyUI/custom_nodes/ComfyUI-Manager 
git clone https://github.com/stavsap/comfyui-ollama.git ComfyUI/custom_nodes/comfyui-ollama 
git clone https://github.com/Jonseed/ComfyUI-Detail-Daemon.git ComfyUI/custom_nodes/ComfyUI-Detail-Daemon 
bash <(curl -s https://raw.githubusercontent.com/emprankem-prog/dw/refs/heads/main/dl.sh)
wget -O /app/ComfyUI/flash_attn-2.7.4.post1+cu12torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl https://github.com/Dao-AILab/flash-attention/releases/download/v2.7.4.post1/flash_attn-2.7.4.post1+cu12torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl 

echo "Installing requirements..." 
curl -fsSL https://ollama.com/install.sh | sh 
nohup ollama serve > /dev/null 2>&1 & 
while ! curl -s http://127.0.0.1:11434; do 
    sleep 1; 
done 
ollama pull qwen2.5vl:3b 
cd ComfyUI 
pip install -r requirements.txt 
pip install opencv_python==4.10.0.82 
pip install sageattention
pip install -r ./custom_nodes/ComfyUI-Manager/requirements.txt 
pip install -r ./custom_nodes/comfyui-ollama/requirements.txt 
pip install -r ./custom_nodes/ComfyUI-Detail-Daemon/requirements.txt 
pip install triton 
pip install flash_attn-2.7.4.post1+cu12torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl 
pip install jupyterlab 
pip uninstall torch 
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu124 

echo "Downloading Models..."
wget -O /app/ComfyUI/models/diffusion_models/flux1-dev-kontext_fp8_scaled.safetensors https://huggingface.co/Comfy-Org/flux1-kontext-dev_ComfyUI/resolve/main/split_files/diffusion_models/flux1-dev-kontext_fp8_scaled.safetensors?download=true 
wget -O /app/ComfyUI/models/clip/t5xxl_fp16.safetensors https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/t5xxl_fp16.safetensors?download=true 
wget -O /app/ComfyUI/models/clip/clip_l.safetensors https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/clip_l.safetensors?download=true 
wget -O /app/ComfyUI/models/vae/ae.safetensors https://huggingface.co/Thelocallab/Flux-Dev-Redux/resolve/main/ae.safetensors?download=true 
wget -O /app/ComfyUI/models/upscale_models/1x-SwatKatsLite.pth https://huggingface.co/Thelocallab/1x-SwatKatsLite/resolve/main/1x-SwatKatsLite.pth?download=true 
wget -O /app/ComfyUI/models/upscale_models/2xLexicaRRDBNet_Sharp.pth https://huggingface.co/Thelocallab/2xLexicaRRDBNet_Sharp/resolve/main/2xLexicaRRDBNet_Sharp.pth?download=true 
wget -O /app/ComfyUI/models/upscale_models/4x_foolhardy_Remacri.pth https://huggingface.co/FacehugmanIII/4x_foolhardy_Remacri/resolve/main/4x_foolhardy_Remacri.pth?download=true 

export GRADIO_SERVER_NAME="0.0.0.0" && 
nohup bash -c "jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token= --NotebookApp.password= --NotebookApp.allow_origin=* & python main.py --listen" > combined.log 2>&1 && 

python --version
