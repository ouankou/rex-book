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
        curl \
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
    
RUN jupyter labextension install @arbennett/base16-monokai

# create user with a home directory
ARG NB_USER=user
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}
WORKDIR ${HOME}
USER ${USER}

ENV SHELL /bin/bash
