#!/usr/bin/env bash

apt update

apt install -y \
  curl \
  gpg

# powershell repo
curl -s https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /etc/apt/trusted.gpg.d/microsoft.gpg
echo "deb [arch=amd64] https://packages.microsoft.com/repos/debian/12 stable main" > /etc/apt/sources.list.d/microsoft-prod.list


apt install -y \
  autoconf \
  automake \
  build-essential \
  ccache \
  cmake \
  crossbuild-essential-arm64 \
  g++-mingw-w64-x86-64 \
  gcc-mingw-w64-x86-64 \
  gettext \
  git \
  libtool \
  m4 \
  mingw-w64 \
  mingw-w64-tools \
  mingw-w64-x86-64-dev \
  nasm \
  ninja-build \
  pkg-config \
  powershell \
  tar \
  texinfo \
  unzip \
  wget \
  zip

rm -rf /var/lib/apt/lists/*

