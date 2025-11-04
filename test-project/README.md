# Cross-Compilation Test Project

Este é um projeto de teste para demonstrar o uso do container de cross-compilation.

## Estrutura

```
test-project/
├── CMakeLists.txt          # Configuração do CMake
├── CMakePresets.json       # Presets para cada plataforma
├── src/
│   └── main.cpp           # Código fonte de teste
└── README.md
```

## Build Local

### Usando o Container Diretamente

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

# Windows ARM64
docker run --rm \
  -v $(pwd):/src \
  -v $(pwd)/build-output/windows-aarch64:/out \
  -e BUILD_TARGET=windows-aarch64 \
  cross-buildenv:latest
```

### Usando CMake Presets (dentro do container)

```bash
docker run --rm -it \
  -v $(pwd):/src \
  -e BUILD_TARGET=linux-aarch64 \
  cross-buildenv:latest \
  bash

# Dentro do container:
cmake --preset linux-aarch64
cmake --build --preset linux-aarch64
```

## Build com CI/CD

O GitHub Actions automaticamente:
1. Builda o container Docker
2. Compila para todas as plataformas (linux-amd64, linux-aarch64, windows-amd64, windows-aarch64)
3. Testa os executáveis:
   - Linux AMD64: execução nativa
   - Linux ARM64: execução com QEMU
   - Windows: verificação do executável
4. Cria packages ZIP para cada plataforma
5. Faz release automático quando uma tag é criada

## Artifacts Gerados

Para cada plataforma, o build gera:
- Executável compilado (`cross-test` ou `cross-test.exe`)
- Arquivo `BUILD_INFO.txt` com informações do build
- Package ZIP: `cross-test-<platform>-<arch>-<version>.zip`

## Testando os Executáveis

### Linux AMD64
```bash
./build-output/linux-amd64/bin/cross-test
```

### Linux ARM64 (com QEMU)
```bash
sudo apt-get install qemu-user-static
qemu-aarch64-static ./build-output/linux-aarch64/bin/cross-test
```

### Windows (com Wine)
```bash
sudo apt-get install wine64
wine ./build-output/windows-amd64/bin/cross-test.exe
```
