FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Set up user
ENV NB_USER=jovyan
ENV NB_UID=1000
ENV HOME=/home/${NB_USER}

# Rename default user to avoid UID conflict
RUN usermod -l ${NB_USER} ubuntu && \
    groupmod -n ${NB_USER} ubuntu && \
    usermod -d ${HOME} -m ${NB_USER}

# 1. Add Kubuntu Backports for Plasma 6
# 2. Install KDE, NoVNC, and a lighter VNC server (TigerVNC) for better stability
RUN apt-get update && apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:kubuntu-ppa/backports && \
    apt-get update && apt-get install -y \
    python3-pip \
    dbus-x11 \
    tigervnc-standalone-server \
    tigervnc-common \
    novnc \
    websockify \
    firefox \
    kde-plasma-desktop && \
    apt-get clean

# Fix the Python package installation for Ubuntu 24.04
RUN pip install --no-cache-dir --break-system-packages \
    jupyter-remote-desktop-proxy \
    jupyter-server-proxy

# Set environment variables to force KDE Plasma 6
ENV XDG_CURRENT_DESKTOP=KDE
ENV JUPYTER_REMOTE_DESKTOP_PROXY_XSTARTUP=startplasma-x11

USER ${NB_USER}
WORKDIR ${HOME}
