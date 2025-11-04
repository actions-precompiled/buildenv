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

O workflow de autorelease (`.github/workflows/autorelease.yaml`) automaticamente:
1. Builda o container Docker unificado
2. Compila o projeto para todas as 3 plataformas como steps sequenciais usando o container
3. Testa cada binário compilado no host do GitHub Actions:
   - Linux AMD64: execução nativa no host
   - Linux ARM64: execução com QEMU no host
   - Windows: verificação do formato no host
4. Cria packages ZIP para cada plataforma
5. Quando uma nova versão é gerada, cria release e faz upload dos 3 ZIPs automaticamente

## Artifacts Gerados

Para cada plataforma, o build gera:
- Executável compilado na pasta `bin/` (`cross-test` ou `cross-test.exe`)
- Arquivo `BUILD_INFO.txt` com informações do build
- Package ZIP: `cross-test-<platform>-<arch>-<version>.zip`

Os binários são automaticamente colocados na pasta `bin/` dentro do diretório de build, facilitando o empacotamento e distribuição.

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
