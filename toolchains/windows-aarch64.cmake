# CMake Toolchain file for Windows ARM64 (aarch64) cross-compilation using MinGW-w64
# Note: MinGW-w64 ARM64 support may be limited or experimental

SET(CMAKE_SYSTEM_NAME Windows)
SET(CMAKE_SYSTEM_PROCESSOR aarch64)

# Specify the cross compiler
# Note: These may need to be adjusted based on your MinGW-w64 ARM64 installation
SET(TOOLCHAIN_PREFIX aarch64-w64-mingw32)
SET(CMAKE_C_COMPILER ${TOOLCHAIN_PREFIX}-gcc)
SET(CMAKE_CXX_COMPILER ${TOOLCHAIN_PREFIX}-g++)
SET(CMAKE_RC_COMPILER ${TOOLCHAIN_PREFIX}-windres)

# Where is the target environment
SET(CMAKE_FIND_ROOT_PATH /usr/${TOOLCHAIN_PREFIX})

# Search for programs in the build host directories
SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)

# For libraries and headers in the target directories
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
SET(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

# Make sure we can find DLLs and static libraries
SET(CMAKE_PREFIX_PATH /usr/${TOOLCHAIN_PREFIX})
