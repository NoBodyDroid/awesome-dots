in/sh
nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits | sed "s/$/°C/"