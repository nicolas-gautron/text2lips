FROM ubuntu:latest

VOLUME ["/home"]

CMD ["bash"]

WORKDIR /home

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    software-properties-common \
    build-essential \
    vim \
    wget \
    curl \
    git \
    ffmpeg \
    sox \
    libsndfile1-dev

RUN add-apt-repository ppa:deadsnakes/ppa

RUN apt-get update && apt-get install -y \
    python3.10 \
    python3.10-venv \
    python3.10-dev \
    python3-pip

RUN python3.10 -m pip install --upgrade pip

# Set python3.10 as the default version
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.10 1 && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1 && \
    update-alternatives --set python /usr/bin/python3.10 && \
    update-alternatives --set python3 /usr/bin/python3.10

# Force using CPU instead of GPU
ENV CUDA_VISIBLE_DEVICES="-1"

RUN pip install torch \
    torchvision \
    torchaudio \
    tensorflow \
    batch-face \
    newspaper3k \
    transformers

# Install Text to Speech and preload the XTTS v2 model
RUN pip install --ignore-installed TTS

ARG PATH_XTTS=/root/.local/share/tts/tts_models--multilingual--multi-dataset--xtts_v2

RUN mkdir -p ${PATH_XTTS} && \
    wget -P ${PATH_XTTS} "https://coqui.gateway.scarf.sh/hf-coqui/XTTS-v2/main/model.pth" && \
    wget -P ${PATH_XTTS} "https://coqui.gateway.scarf.sh/hf-coqui/XTTS-v2/main/config.json" && \
    wget -P ${PATH_XTTS} "https://coqui.gateway.scarf.sh/hf-coqui/XTTS-v2/main/vocab.json" && \
    wget -P ${PATH_XTTS} "https://coqui.gateway.scarf.sh/hf-coqui/XTTS-v2/main/hash.md5" && \
    wget -P ${PATH_XTTS} "https://coqui.gateway.scarf.sh/hf-coqui/XTTS-v2/main/speakers_xtts.pth"

# Install Wav2Lip, the lip sync project.
RUN mkdir /vendor \
    && cd /vendor \
    && git clone https://github.com/justinjohn0306/Wav2Lip.git \
    && sed -i 's/gpu_id=0/gpu_id=-1/g' /vendor/Wav2Lip/inference.py

COPY assets/Wav2Lip/checkpoints/* /vendor/Wav2Lip/checkpoints/
COPY assets/Wav2Lip/s3fd.pth /vendor/Wav2Lip/face_detection/detection/sfd/

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*
