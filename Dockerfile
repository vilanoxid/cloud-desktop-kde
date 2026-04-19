# 1. Start with a solid Linux base
FROM mcr.microsoft.com/devcontainers/universal:latest

# 2. Install the lightweight Desktop (Fluxbox) and the Web Bridge (noVNC)
USER root
RUN apt-get update && apt-get install -y \
    xvfb \
    fluxbox \
    x11vnc \
    novnc \
    websockify

# 3. Set the "Video Output" port to be public
EXPOSE 6080
