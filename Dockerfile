# Ubuntu 24.04 (Noble Numbat)
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Setup user
ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV HOME /home/${NB_USER}
RUN useradd -m -s /bin/bash -N -u ${NB_UID} ${NB_USER}

# 1. Install software-properties-common to add PPAs
# 2. Add Kubuntu Backports for Plasma 6
# 3. Install core KDE, NoVNC, and Firefox
RUN apt-get update && apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:kubuntu-ppa/backports && \
    apt-get update && apt-get install -y \
    python3-pip \
    python3-dev \
    dbus-x11 \
    x11vnc \
    xvfb \
    novnc \
    firefox \
    kde-plasma-desktop \
    plasma-nm && \
    apt-get clean

# Install the Desktop Bridge
RUN pip install --no-cache-dir --break-system-packages jupyter-remote-desktop-proxy

# Add a command to show the version in the terminal on startup
RUN echo 'echo "--- SYSTEM INFO ---"' >> ${HOME}/.bashrc && \
    echo 'plasmashell --version' >> ${HOME}/.bashrc && \
    echo 'echo "-------------------"' >> ${HOME}/.bashrc

USER ${NB_USER}
WORKDIR ${HOME}
