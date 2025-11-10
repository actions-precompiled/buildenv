FROM debian:stable

# Create working directories
RUN mkdir -p /src /out /toolchains /ccache
WORKDIR /src

# Update package list and install base build tools
RUN apt update && apt install -y \
    autoconf \
    automake \
    build-essential \
    ccache \
    cmake \
    crossbuild-essential-arm64 \
    curl \
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
    texinfo \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Copy toolchain files
COPY toolchains/*.cmake /toolchains/

# Copy entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# Environment setup
ENV PATH="/usr/local/bin:${PATH}"
ENV SOURCE_DIR="/src"
ENV BUILD_DIR="/out"
ENV CCACHE_DIR="/ccache"

# Set entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
