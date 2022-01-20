FROM nvidia/cuda:11.6.0-devel-ubuntu20.04

ENV TZ=US/Eastern
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN \
    apt update && \
    apt install -y \
        apt-utils \
        curl \
        dialog \
        software-properties-common

RUN curl -fsSL https://deb.nodesource.com/setup_17.x | bash -

RUN \
    apt install -y python3-pip && \
    apt install -y \ 
        automake \
        bison \
        build-essential \
        clang \
        cmake \
        flex \
        g++ \
        gcc \
        gcc-multilib \
        gdb \
        gfortran \
        ghostscript \
        git \
        graphviz \
        libboost-all-dev \
        libomp-dev \
        libtinfo-dev \
        libtool \
        ninja-build \
        nodejs \
        openjdk-8-jdk \
        vim \
        wget \
        zlib1g-dev && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/*

# install the notebook package
RUN pip install --no-cache --upgrade pip && \
    pip install --no-cache notebook jupyterlab
    
RUN jupyter labextension install @arbennett/base16-gruvbox-dark

# create user with a home directory
ARG NB_USER
ARG NB_UID
ENV USER ${NB_USER}
ENV HOME /home/${NB_USER}

COPY . ${HOME}
RUN chown -R ${NB_UID} ${HOME}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}
WORKDIR ${HOME}
USER ${USER}

RUN mkdir -p ${HOME}/.jupyter/lab/jupyterlab/user-settings/@jupyterlab/apputils-extension && \
    echo '{ "theme":"gruvbox-dark" }' > ${HOME}/.jupyter/lab/user-settings/@jupyterlab/apputils-extension/themes.jupyterlab-settings

RUN mkdir -p ${HOME}/.jupyter/lab/jupyterlab/user-settings/@jupyterlab/terminal-extension && \
    echo '{ "fontSize": 16 }' > ${HOME}/.jupyter/lab/user-settings/@jupyterlab/terminal-extension/plugin.jupyterlab-settings

ENV SHELL /bin/bash
