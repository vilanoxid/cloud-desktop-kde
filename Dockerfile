# Using Fedora 44 for the absolute latest KDE Plasma 6 builds
FROM fedora:44

# Setup a non-root user (Security requirement for Binder)
ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV HOME /home/${NB_USER}
RUN useradd -m -s /bin/bash -N -u ${NB_UID} ${NB_USER}

# Install KDE Plasma, NoVNC (for browser viewing), and dependencies
RUN dnf install -y \
    @kde-desktop-environment \
    novnc \
    python3-pip \
    x11vnc \
    tigervnc-server \
    xorg-x11-server-Xvfb \
    firefox && \
    dnf clean all

# Install the proxy that allows the Desktop to show up in Jupyter
RUN pip install --no-cache-dir jupyter-remote-desktop-proxy

USER ${NB_USER}
WORKDIR ${HOME}
