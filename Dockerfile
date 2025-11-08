# Base image
FROM ubuntu:22.04

# Compilation arguments
ARG USER_ID
ARG USER_NAME
ARG GROUP_ID
ARG GROUP_NAME
ARG WORKSPACE

# Environment configuration
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# Basic system installation
RUN apt-get update && apt-get install -y \
    sudo \
    build-essential \
    curl \
    wget \
    git \
    vim \
    nano \
    net-tools \
    iputils-ping \
    python3 \
    python3-pip \
    locales \
    && locale-gen en_US.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

# Non privileged user setup
RUN groupadd -g ${GROUP_ID} ${GROUP_NAME} \
    && useradd -u ${USER_ID} -g ${GROUP_ID} -m -s /bin/bash ${USER_NAME} \
    && echo "${USER_NAME}:${USER_NAME}" | chpasswd \
    && adduser ${USER_NAME} sudo


# Grant access to video devices
RUN usermod -aG video $USER_NAME

# Switch to the new user
USER $USER_ID

# Create and set the working directory
WORKDIR /home/$USER_NAME/$WORKSPACE

# Install pip packages
RUN python3 -m pip install --upgrade pip

RUN pip install opencv-python && \
    pip install numpy

# Path and environment setup
RUN export PATH=$PATH:/home/$USER_NAME/.local/bin && \
    echo "export PATH=$PATH:/home/$USER_NAME/.local/bin" >> /home/$USER_NAME/.bashrc

# Default command
CMD ["tail", "-f", "/dev/null"]
