# Cross-Compilation Build Environment

Docker container com todos os cross-compilers e toolchains do CMake para compilar projetos C/C++ para múltiplas plataformas.

## Plataformas Suportadas

- **Linux AMD64** (x86_64) - compilação nativa
- **Linux ARM64** (aarch64) - cross-compilation
- **Windows AMD64** (x86_64) - cross-compilation com MinGW-w64
- **Windows ARM64** (aarch64) - cross-compilation com MinGW-w64 (experimental)

## Build do Container

```bash
docker build -t cross-buildenv .
```

## Uso

### Compilação Básica

Para cada plataforma, use o toolchain correspondente:

```bash
# Linux AMD64 (nativo)
docker run --rm -v $(pwd):/src cross-buildenv \
  cmake -B build -G Ninja -DCMAKE_TOOLCHAIN_FILE=/toolchains/linux-amd64.cmake
docker run --rm -v $(pwd):/src cross-buildenv ninja -C build

# Linux ARM64
docker run --rm -v $(pwd):/src cross-buildenv \
  cmake -B build-arm64 -G Ninja -DCMAKE_TOOLCHAIN_FILE=/toolchains/linux-aarch64.cmake
docker run --rm -v $(pwd):/src cross-buildenv ninja -C build-arm64

# Windows AMD64
docker run --rm -v $(pwd):/src cross-buildenv \
  cmake -B build-windows -G Ninja -DCMAKE_TOOLCHAIN_FILE=/toolchains/windows-amd64.cmake
docker run --rm -v $(pwd):/src cross-buildenv ninja -C build-windows

# Windows ARM64 (experimental)
docker run --rm -v $(pwd):/src cross-buildenv \
  cmake -B build-windows-arm64 -G Ninja -DCMAKE_TOOLCHAIN_FILE=/toolchains/windows-aarch64.cmake
docker run --rm -v $(pwd):/src cross-buildenv ninja -C build-windows-arm64
```

### Exemplo com Script de Build

Crie um script `build.sh`:

```bash
#!/bin/bash
PLATFORM=${1:-linux-amd64}
BUILD_DIR="build-${PLATFORM}"

docker run --rm -v $(pwd):/src cross-buildenv \
  cmake -B ${BUILD_DIR} -G Ninja -DCMAKE_TOOLCHAIN_FILE=/toolchains/${PLATFORM}.cmake

docker run --rm -v $(pwd):/src cross-buildenv ninja -C ${BUILD_DIR}
```

Use assim:

```bash
./build.sh linux-amd64
./build.sh linux-aarch64
./build.sh windows-amd64
./build.sh windows-aarch64
```

### Exemplo Avançado

```bash
# Compilar com configurações customizadas
docker run --rm -v $(pwd):/src -v $(pwd)/output:/out cross-buildenv bash -c "
  cmake -B build -G Ninja \
    -DCMAKE_TOOLCHAIN_FILE=/toolchains/linux-aarch64.cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/out
  ninja -C build
  ninja -C build install
"
```

## Toolchains Disponíveis

Todos os toolchains estão em `/toolchains/` dentro do container:

- `/toolchains/linux-amd64.cmake` - Linux x86_64 nativo
- `/toolchains/linux-aarch64.cmake` - Linux ARM64
- `/toolchains/windows-amd64.cmake` - Windows x86_64 (MinGW)
- `/toolchains/windows-aarch64.cmake` - Windows ARM64 (MinGW, experimental)

## Notas

- O suporte para Windows ARM64 é experimental e pode não estar disponível em todas as versões do MinGW-w64
- O container é baseado em Debian stable para maior estabilidade
- Todos os diretórios `/src` e `/out` são pré-criados no container
