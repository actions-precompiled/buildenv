#include <iostream>
#include <string>

#ifdef _WIN32
    #define PLATFORM "Windows"
#else
    #define PLATFORM "Linux"
#endif

#ifdef __x86_64__
    #define ARCH "x86_64"
#elif defined(__aarch64__)
    #define ARCH "aarch64"
#else
    #define ARCH "unknown"
#endif

int main() {
    std::cout << "Cross-Compilation Test Application" << std::endl;
    std::cout << "===================================" << std::endl;
    std::cout << "Platform: " << PLATFORM << std::endl;
    std::cout << "Architecture: " << ARCH << std::endl;
    std::cout << "Compiled successfully!" << std::endl;
    return 0;
}
