# Cross-Compilation Build Environment

Docker container with all cross-compilers and CMake toolchains to compile C/C++ projects for multiple platforms.

## Supported Platforms

- **Linux AMD64** (x86_64) - native compilation
- **Linux ARM64** (aarch64) - cross-compilation
- **Windows AMD64** (x86_64) - cross-compilation with MinGW-w64

## Build Container

```bash
docker build -t cross-buildenv .
```

## Usage

### Automatic Mode (with Entrypoint)

The container has an entrypoint that automatically configures the toolchain based on the `BUILD_TARGET` environment variable:

```bash
# Linux AMD64
docker run --rm \
  -v $(pwd):/src \
  -v $(pwd)/output/linux-amd64:/out \
  -e BUILD_TARGET=linux-amd64 \
  cross-buildenv

# Linux ARM64
docker run --rm \
  -v $(pwd):/src \
  -v $(pwd)/output/linux-aarch64:/out \
  -e BUILD_TARGET=linux-aarch64 \
  cross-buildenv

# Windows AMD64
docker run --rm \
  -v $(pwd):/src \
  -v $(pwd)/output/windows-amd64:/out \
  -e BUILD_TARGET=windows-amd64 \
  cross-buildenv
```

The entrypoint automatically:
1. Configures CMake with the correct toolchain
2. Compiles the project
3. Executes the `package-zip` target

### Usage in Projects

To use the container in your CI/CD projects, you can pull the image from the registry:

```bash
# Pull image
docker pull ghcr.io/actions-precompiled/buildenv:latest

# Use to compile
docker run --rm \
  -v $(pwd):/src \
  -v $(pwd)/output:/out \
  -e BUILD_TARGET=linux-aarch64 \
  ghcr.io/actions-precompiled/buildenv:latest
```

## Available Toolchains

All toolchains are in `/toolchains/` inside the container:

- `/toolchains/linux-amd64.cmake` - Native Linux x86_64
- `/toolchains/linux-aarch64.cmake` - Linux ARM64
- `/toolchains/windows-amd64.cmake` - Windows x86_64 (MinGW)

## Test Project

The repository includes a complete test project in `test-project/` that demonstrates the container usage.

### Build Test Project

```bash
# Build container
docker build -t cross-buildenv .

# Build for all platforms
cd test-project

# Linux AMD64
docker run --rm \
  -v $(pwd):/src \
  -v $(pwd)/build-output/linux-amd64:/out \
  -e BUILD_TARGET=linux-amd64 \
  cross-buildenv

# Linux ARM64
docker run --rm \
  -v $(pwd):/src \
  -v $(pwd)/build-output/linux-aarch64:/out \
  -e BUILD_TARGET=linux-aarch64 \
  cross-buildenv

# Windows AMD64
docker run --rm \
  -v $(pwd):/src \
  -v $(pwd)/build-output/windows-amd64:/out \
  -e BUILD_TARGET=windows-amd64 \
  cross-buildenv
```

### CI/CD

The project includes an autorelease workflow (`.github/workflows/autorelease.yaml`) that:
1. Builds the unified Docker container
2. Compiles the test project for all platforms (linux-amd64, linux-aarch64, windows-amd64) using the container
3. Tests the compiled binaries on the GitHub Actions host:
   - Linux AMD64: native execution
   - Linux ARM64: execution with QEMU
   - Windows: format verification
4. Creates ZIP packages for each platform
5. Creates automatic release and uploads ZIPs when a new version is generated

## Environment Variables

- `BUILD_TARGET`: Defines the target platform (linux-amd64, linux-aarch64, windows-amd64)
- `SOURCE_DIR`: Directory with source code (default: `/src`)
- `BUILD_DIR`: Build output directory (default: `/out`)

## Notes

- The container is based on Debian stable for greater stability
- All `/src` and `/out` directories are pre-created in the container
- The entrypoint automatically detects and applies the correct toolchain based on `BUILD_TARGET`
- Binaries are generated in the `bin/` folder inside the build directory to facilitate packaging
