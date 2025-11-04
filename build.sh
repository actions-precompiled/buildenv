#!/bin/bash
set -e

# Cross-compilation build script
# Usage: ./build.sh <platform> [additional cmake args]
# Platforms: linux-amd64, linux-aarch64, windows-amd64, windows-aarch64

PLATFORM=${1:-linux-amd64}
BUILD_DIR="build-${PLATFORM}"
CONTAINER_IMAGE="cross-buildenv"

# Check if platform is valid
TOOLCHAIN_FILE="/toolchains/${PLATFORM}.cmake"
VALID_PLATFORMS=("linux-amd64" "linux-aarch64" "windows-amd64" "windows-aarch64")

if [[ ! " ${VALID_PLATFORMS[@]} " =~ " ${PLATFORM} " ]]; then
    echo "Error: Invalid platform '${PLATFORM}'"
    echo "Valid platforms: ${VALID_PLATFORMS[@]}"
    exit 1
fi

# Shift to get additional cmake args
shift || true

echo "Building for platform: ${PLATFORM}"
echo "Build directory: ${BUILD_DIR}"
echo "Toolchain file: ${TOOLCHAIN_FILE}"

# Configure with CMake
echo "Configuring with CMake..."
docker run --rm -v "$(pwd):/src" "${CONTAINER_IMAGE}" \
    cmake -B "${BUILD_DIR}" -G Ninja \
    -DCMAKE_TOOLCHAIN_FILE="${TOOLCHAIN_FILE}" \
    "$@"

# Build with Ninja
echo "Building with Ninja..."
docker run --rm -v "$(pwd):/src" "${CONTAINER_IMAGE}" \
    ninja -C "${BUILD_DIR}"

echo "Build complete! Output in ${BUILD_DIR}/"
