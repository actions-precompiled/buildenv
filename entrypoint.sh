#!/bin/bash
set -e

# Cross-compilation container entrypoint
# This script configures and builds CMake projects with automatic toolchain selection

# Default values
BUILD_TARGET="${BUILD_TARGET:-linux-amd64}"
SOURCE_DIR="${SOURCE_DIR:-/src}"
BUILD_DIR="${BUILD_DIR:-/out}"
CCACHE_DIR="${CCACHE_DIR:-/ccache}"

# Configure ccache
export CCACHE_DIR

# Validate BUILD_TARGET
VALID_TARGETS=("linux-amd64" "linux-aarch64" "windows-amd64")
if [[ ! " ${VALID_TARGETS[@]} " =~ " ${BUILD_TARGET} " ]]; then
    echo "Error: Invalid BUILD_TARGET '${BUILD_TARGET}'"
    echo "Valid targets: ${VALID_TARGETS[@]}"
    exit 1
fi

# Set toolchain file
TOOLCHAIN_FILE="/toolchains/${BUILD_TARGET}.cmake"

echo "========================================="
echo "Cross-Compilation Build Container"
echo "========================================="
echo "BUILD_TARGET: ${BUILD_TARGET}"
echo "SOURCE_DIR: ${SOURCE_DIR}"
echo "BUILD_DIR: ${BUILD_DIR}"
echo "TOOLCHAIN_FILE: ${TOOLCHAIN_FILE}"
echo "CCACHE_DIR: ${CCACHE_DIR}"
echo "========================================="
echo "ccache stats (before build):"
ccache -s
echo "========================================="

# Check if source directory exists
if [ ! -d "${SOURCE_DIR}" ]; then
    echo "Error: Source directory '${SOURCE_DIR}' does not exist"
    exit 1
fi

# Create build directory if it doesn't exist
mkdir -p "${BUILD_DIR}"

# If no arguments provided, run default configure + build + package
if [ $# -eq 0 ]; then
    echo "Running default build process..."
    echo ""

    echo "Step 1: Configuring with CMake..."
    cmake -S "${SOURCE_DIR}" \
          -B "${BUILD_DIR}" \
          -G Ninja \
          -DCMAKE_TOOLCHAIN_FILE="${TOOLCHAIN_FILE}" \
          -DCMAKE_BUILD_TYPE=Release

    echo ""
    echo "Step 2: Building..."
    cmake --build "${BUILD_DIR}" --target all

    echo ""
    echo "Step 3: Creating package..."
    cmake --build "${BUILD_DIR}" --target package-zip

    echo ""
    echo "========================================="
    echo "Build completed successfully!"
    echo "Output directory: ${BUILD_DIR}"
    echo "========================================="
    echo "ccache stats (after build):"
    ccache -s
    echo "========================================="

else
    # Custom command mode - pass everything to cmake
    echo "Running custom CMake command..."
    echo "Command: cmake -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_FILE} $@"
    echo ""

    exec cmake -DCMAKE_TOOLCHAIN_FILE="${TOOLCHAIN_FILE}" "$@"
fi
