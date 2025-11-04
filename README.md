# Cross-Compilation Build Environment

Docker container com todos os cross-compilers e toolchains do CMake para compilar projetos C/C++ para múltiplas plataformas.

## Plataformas Suportadas

- **Linux AMD64** (x86_64) - compilação nativa
- **Linux ARM64** (aarch64) - cross-compilation
- **Windows AMD64** (x86_64) - cross-compilation com MinGW-w64

## Build do Container

```bash
docker build -t cross-buildenv .
```

## Uso

### Modo Automático (com Entrypoint)

O container possui um entrypoint que configura automaticamente o toolchain baseado na variável de ambiente `BUILD_TARGET`:

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

O entrypoint automaticamente:
1. Configura o CMake com o toolchain correto
2. Compila o projeto
3. Executa o target `package-zip`

### Uso em Projetos

Para usar o container em seus projetos de CI/CD, você pode puxar a imagem do registro:

```bash
# Pull da imagem
docker pull ghcr.io/actions-precompiled/buildenv:latest

# Usar para compilar
docker run --rm \
  -v $(pwd):/src \
  -v $(pwd)/output:/out \
  -e BUILD_TARGET=linux-aarch64 \
  ghcr.io/actions-precompiled/buildenv:latest
```

## Toolchains Disponíveis

Todos os toolchains estão em `/toolchains/` dentro do container:

- `/toolchains/linux-amd64.cmake` - Linux x86_64 nativo
- `/toolchains/linux-aarch64.cmake` - Linux ARM64
- `/toolchains/windows-amd64.cmake` - Windows x86_64 (MinGW)

## Projeto de Teste

O repositório inclui um projeto de teste completo em `test-project/` que demonstra o uso do container.

### Build do Projeto de Teste

```bash
# Build do container
docker build -t cross-buildenv .

# Build para todas as plataformas
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

O projeto inclui um workflow de autorelease (`.github/workflows/autorelease.yaml`) que:
1. Builda o container Docker unificado
2. Compila o projeto de teste para todas as plataformas (linux-amd64, linux-aarch64, windows-amd64) usando o container
3. Testa os binários compilados no host do GitHub Actions:
   - Linux AMD64: execução nativa
   - Linux ARM64: execução com QEMU
   - Windows: verificação do formato
4. Cria packages ZIP para cada plataforma
5. Cria release automático e faz upload dos ZIPs quando uma nova versão é gerada

## Variáveis de Ambiente

- `BUILD_TARGET`: Define a plataforma alvo (linux-amd64, linux-aarch64, windows-amd64)
- `SOURCE_DIR`: Diretório com o código fonte (padrão: `/src`)
- `BUILD_DIR`: Diretório de saída do build (padrão: `/out`)

## Notas

- O container é baseado em Debian stable para maior estabilidade
- Todos os diretórios `/src` e `/out` são pré-criados no container
- O entrypoint automaticamente detecta e aplica o toolchain correto baseado em `BUILD_TARGET`
- Os binários são gerados na pasta `bin/` dentro do diretório de build para facilitar o empacotamento
