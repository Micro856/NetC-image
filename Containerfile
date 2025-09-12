# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY build_files /

# Base Image
FROM quay.io/fedora/fedora-bootc:latest

## Other possible base images include:
# FROM ghcr.io/ublue-os/bazzite:latest
# FROM ghcr.io/ublue-os/bluefin-nvidia:stable
# 
# ... and so on, here are more base images
# Universal Blue Images: https://github.com/orgs/ublue-os/packages
# Fedora base image: quay.io/fedora/fedora-bootc:41
# CentOS base images: quay.io/centos-bootc/centos-bootc:stream10

### MODIFICATIONS
## make modifications desired in your image and install packages by modifying the build.sh script
## the following RUN directive does all the things required to run "build.sh" as recommended.

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    dnf install -y git && \
    cd /tmp
    git clone https://github.com/Micro856/NetC.git && \
    mkdir -p /usr/share/bootcrew/netc && \
    cp /tmp/NetC/main.py /usr/share/bootcrew/netc/main.py && \
    cp /tmp/NetC/netc /bin/netc && \
    cp /tmp/NetC/bashrc /etc/skel/.bashrc && \
    cp /tmp/NetC/bash_profile /etc/skel/.bash_profile && \
    cd /
    rm -rf /tmp/NetC
    /ctx/build.sh && \
    ostree container commit
    
### LINTING
## Verify final image and contents are correct.
RUN bootc container lint
