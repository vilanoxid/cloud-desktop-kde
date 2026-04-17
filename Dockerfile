
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Set up environment variables
ENV NB_USER=jovyan
ENV NB_UID=1000
ENV HOME=/home/${NB_USER}

# Fix: Instead of creating a new user, we rename the existing 'ubuntu' user to 'jovyan'
RUN usermod -l ${NB_USER} ubuntu && \
    groupmod -n ${NB_USER} ubuntu && \
    usermod -d ${HOME} -m ${NB_USER}

# Install PPAs and KDE Plasma 6
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

# Version check for startup
RUN echo 'echo "--- KDE PLASMA VERSION CHECK ---"' >> ${HOME}/.bashrc && \
    echo 'plasmashell --version || echo "KDE starting up..."' >> ${HOME}/.bashrc && \
    echo 'echo "---------------------------------"' >> ${HOME}/.bashrc

USER ${NB_USER}
WORKDIR ${HOME}
