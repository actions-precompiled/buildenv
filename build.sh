#!/usr/bin/env bash

set -exuo pipefail

apt update

apt install -y \
  wget \
  curl \
  gpg

# powershell repo
wget -q "https://packages.microsoft.com/config/debian/$(grep -oE '[0-9]+' /etc/debian_version | head -1)/packages-microsoft-prod.deb"
dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb


apt update
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
  powershell-lts \
  tar \
  texinfo \
  unzip \
  zip

pwsh --version

rm -rf /var/lib/apt/lists/*

