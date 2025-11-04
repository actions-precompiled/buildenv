FROM debian:stable

# Create working directories
RUN mkdir -p /src /out /toolchains
WORKDIR /src

# Update package list and install base build tools
RUN apt update && apt install -y \
    build-essential \
    cmake \
    ninja-build \
    git \
    crossbuild-essential-arm64 \
    g++-mingw-w64-x86-64 \
    gcc-mingw-w64-x86-64 \
    g++-mingw-w64-i686 \
    gcc-mingw-w64-i686 \
    && rm -rf /var/lib/apt/lists/*

# Copy toolchain files
COPY toolchains/*.cmake /toolchains/

# Environment setup
ENV PATH="/usr/local/bin:${PATH}"

# Default command
CMD ["/bin/bash"]
