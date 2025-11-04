# Cross-Compilation Test Project

This is a test project to demonstrate the usage of the cross-compilation container.

## Structure

```
test-project/
├── CMakeLists.txt          # CMake configuration
├── CMakePresets.json       # Presets for each platform
├── src/
│   └── main.cpp           # Test source code
└── README.md
```

## Local Build

### Using Container Directly

```bash
# Linux AMD64
docker run --rm \
  -v $(pwd):/src \
  -v $(pwd)/build-output/linux-amd64:/out \
  -e BUILD_TARGET=linux-amd64 \
  cross-buildenv:latest

# Linux ARM64
docker run --rm \
  -v $(pwd):/src \
  -v $(pwd)/build-output/linux-aarch64:/out \
  -e BUILD_TARGET=linux-aarch64 \
  cross-buildenv:latest

# Windows AMD64
docker run --rm \
  -v $(pwd):/src \
  -v $(pwd)/build-output/windows-amd64:/out \
  -e BUILD_TARGET=windows-amd64 \
  cross-buildenv:latest
```

### Using CMake Presets (inside container)

```bash
docker run --rm -it \
  -v $(pwd):/src \
  -e BUILD_TARGET=linux-aarch64 \
  cross-buildenv:latest \
  bash

# Inside container:
cmake --preset linux-aarch64
cmake --build --preset linux-aarch64
```

## Build with CI/CD

The autorelease workflow (`.github/workflows/autorelease.yaml`) automatically:
1. Builds the unified Docker container
2. Compiles the project for all 3 platforms as sequential steps using the container
3. Tests each compiled binary on the GitHub Actions host:
   - Linux AMD64: native execution on host
   - Linux ARM64: execution with QEMU on host
   - Windows: execution with Wine on host
4. Creates ZIP packages for each platform
5. When a new version is generated, creates a release and uploads the 3 ZIPs automatically

## Generated Artifacts

For each platform, the build generates:
- Compiled executable in the `bin/` folder (`cross-test` or `cross-test.exe`)
- `BUILD_INFO.txt` file with build information
- ZIP package: `cross-test-<platform>-<arch>-<version>.zip`

Binaries are automatically placed in the `bin/` folder inside the build directory, facilitating packaging and distribution.

## Testing Executables

### Linux AMD64
```bash
./build-output/linux-amd64/bin/cross-test
```

### Linux ARM64 (with QEMU)
```bash
sudo apt-get install qemu-user-static
qemu-aarch64-static ./build-output/linux-aarch64/bin/cross-test
```

### Windows (with Wine)
```bash
sudo apt-get install wine64
wine ./build-output/windows-amd64/bin/cross-test.exe
```
