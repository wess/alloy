FROM debian:bullseye

ENV container docker
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y -q \
    apt-utils \
    zsh \
    nano \
    vim \
    make \
    locales \
    g++ \
    gcc \
    git \
    build-essential \
    curl \
    debianutils \
    binutils \
    sed \
    unzip \
    curl \
    wget \
    nfs-common \
    fdisk \
    procps \
    qemu \
    qemu-user-static \
    binfmt-support \
    aria2 \
    cloud-guest-utils \
    python3-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && pip install niet

RUN echo "dash dash/sh boolean false" | debconf-set-selections
RUN dpkg-reconfigure dash
RUN sed -i "s/^# en_US.UTF-8/en_US.UTF-8/" /etc/locale.gen && locale-gen && update-locale LANG=en_US.UTF-8
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

COPY ancilla_os /ancilla_os

WORKDIR /alloy

ENV DEBIAN_FRONTEND=dialog
ENV PATH=/alloy:${PATH}

ENTRYPOINT [ "zsh" ]