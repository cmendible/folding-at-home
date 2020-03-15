FROM debian:stable-slim

# fahclient version
ARG FAHCLIENT_VERSION=7.5.1
ARG FAHCLIENT_MAJOR_VERSION=7.5

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# This Dockerfile adds a non-root user with sudo access.
ARG USERNAME=fah
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN apt-get update \
    && apt-get -y install --no-install-recommends apt-utils dialog 2>&1 \
    #
    # install curl ca-certificates bzip2
    && apt-get install -y \
    curl \
    ca-certificates \
    bzip2 \
    #
    # install FAHCLIENT
    && mkdir -p /tmp/docker-downloads \
    && curl -o /tmp/docker-downloads/fahclient.deb https://download.foldingathome.org/releases/public/release/fahclient/debian-stable-64bit/v${FAHCLIENT_MAJOR_VERSION}/fahclient_${FAHCLIENT_VERSION}_amd64.deb \
    && mkdir -p /etc/fahclient/ \
    && touch /etc/fahclient/config.xml \
    && dpkg --install /tmp/docker-downloads/fahclient.deb \
    #
    # Create a non-root user to use if preferred
    && groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    # Add sudo support for the non-root user
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME\
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    #
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog

ENTRYPOINT ["FAHClient"]
CMD ["--user=Anonymous", "--team=0", "--gpu=false", "--smp=true", "--power=medium"]
