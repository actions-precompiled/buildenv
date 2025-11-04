cmake_minimum_required(VERSION 3.20)
project(CrossCompileTest VERSION 1.0.0)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Detect platform and architecture
if(CMAKE_SYSTEM_NAME STREQUAL "Windows")
    set(PLATFORM_NAME "windows")
elseif(CMAKE_SYSTEM_NAME STREQUAL "Linux")
    set(PLATFORM_NAME "linux")
else()
    set(PLATFORM_NAME "unknown")
endif()

if(CMAKE_SYSTEM_PROCESSOR MATCHES "x86_64|AMD64")
    set(ARCH_NAME "amd64")
elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "aarch64|ARM64")
    set(ARCH_NAME "aarch64")
else()
    set(ARCH_NAME "unknown")
endif()

set(TARGET_NAME "${PLATFORM_NAME}-${ARCH_NAME}")
message(STATUS "Building for: ${TARGET_NAME}")

# Main executable
add_executable(cross-test src/main.cpp)

# Installation rules
install(TARGETS cross-test DESTINATION bin)

# Create a simple info file
file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/BUILD_INFO.txt"
    "Platform: ${PLATFORM_NAME}\nArchitecture: ${ARCH_NAME}\nBuild Type: ${CMAKE_BUILD_TYPE}\n")
install(FILES "${CMAKE_CURRENT_BINARY_DIR}/BUILD_INFO.txt" DESTINATION .)

# CPack configuration for ZIP packages
set(CPACK_GENERATOR "ZIP")
set(CPACK_PACKAGE_NAME "cross-test")
set(CPACK_PACKAGE_VERSION "${PROJECT_VERSION}")
set(CPACK_PACKAGE_FILE_NAME "cross-test-${TARGET_NAME}-${PROJECT_VERSION}")
set(CPACK_INCLUDE_TOPLEVEL_DIRECTORY OFF)

include(CPack)

# Custom target for easy packaging
add_custom_target(package-zip
    COMMAND ${CMAKE_CPACK_COMMAND} -G ZIP -C $<CONFIG>
    DEPENDS cross-test
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    COMMENT "Creating ZIP package for ${TARGET_NAME}"
)
