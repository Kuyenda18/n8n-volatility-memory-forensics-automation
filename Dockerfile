FROM n8nio/n8n:latest-debian

USER root

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        bzip2 \
        ca-certificates \
        wget \
    && rm -rf /var/lib/apt/lists/*

RUN wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh \
    && bash /tmp/miniconda.sh -b -p /opt/conda \
    && rm /tmp/miniconda.sh \
    && /opt/conda/bin/conda clean -afy

RUN /opt/conda/bin/pip install --no-cache-dir \
    capstone \
    pefile \
    setuptools \
    wheel \
    yara-python

ENV PATH="/opt/conda/bin:${PATH}"

USER node
