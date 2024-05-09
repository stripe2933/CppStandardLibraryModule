# CppStandardLibraryModule

![Clang CI](https://github.com/stripe2933/CppStandardLibraryModule/actions/workflows/clang.yml/badge.svg)
![MSVC CI](https://github.com/stripe2933/CppStandardLibraryModule/actions/workflows/msvc.yml/badge.svg)

Enable [C++23 standard library module feature, a.k.a. `import std` (P2465R3)](https://wg21.link/P2465R3) in your CMake (≥ 3.26) project.
It also [supported in C++20 as compiler extension](https://github.com/microsoft/STL/issues/3945).

## How to do?

There are prerequisites for using this repository.

- Your compiler must support the standard library module feature.
  - [Clang ≥ 17 with custom module build](https://libcxx.llvm.org/Modules.html): support for both [C++20](https://reviews.llvm.org/D158358) and C++23. Ninja ≥ 1.11 is required.
  - [MSVC](https://learn.microsoft.com/en-us/cpp/cpp/tutorial-import-stl-named-module?view=msvc-170): support for C++23 (≥ 19.36), C++20 (≥ 19.38).
- You need CMake ≥ 3.26 for module support in CMake.

All prerequisites satisfied, your simplest program will be:

`CMakeLists.txt`
```cmake
cmake_minimum_required(VERSION 3.28)
project(CppStandardLibraryModule)

# --------------------
# Enable C++20 module support in CMake.
# Below code must be uncommented when use CMake < 3.28.
# --------------------

#if (CMAKE_VERSION VERSION_LESS "3.28.0")
#    if(CMAKE_VERSION VERSION_LESS "3.27.0")
#        set(CMAKE_EXPERIMENTAL_CXX_MODULE_CMAKE_API "2182bf5c-ef0d-489a-91da-49dbc3090d2a")
#    else()
#        set(CMAKE_EXPERIMENTAL_CXX_MODULE_CMAKE_API "aa1f7df0-828a-4fcd-9afc-2dc80491aca7")
#    endif()
#    set(CMAKE_EXPERIMENTAL_CXX_MODULE_DYNDEP 1)
#else()
#    cmake_policy(VERSION 3.28)
#endif()

# --------------------
# Include CMake scripts.
# --------------------

file(DOWNLOAD https://raw.githubusercontent.com/stripe2933/CppStandardLibraryModule/main/cmake/EnableStandardLibraryModule.cmake
    ${CMAKE_BINARY_DIR}/EnableStandardLibraryModule.cmake
)
include(${CMAKE_BINARY_DIR}/EnableStandardLibraryModule.cmake)

# --------------------
# Main executable.
# --------------------

add_executable(CppStandardLibraryModule main.cpp)
```

`main.cpp`
```c++
import std;
// import std.compat also available.

int main(){
    std::cout << "Hello, world!\n";
}
```

Or simply, you can just clone this template repository.

### Clang

Build Standard Library Module from LLVM repository.

```shell
git clone https://github.com/llvm/llvm-project.git
cd llvm-project
mkdir build
cmake -G Ninja -S runtimes -B build \
  -DLLVM_ENABLE_RUNTIMES="libcxx;libcxxabi;libunwind"
ninja -C build
```

After that, specify the CMake variable `LIBCXX_BUILD` to your custom module build directory, explained at [Libc++ website](https://libcxx.llvm.org/Modules.html) in detail.

```shell
cd <your-project-dir>
mkdir build
cmake -S . -B build -G Ninja \
  -DCMAKE_CXX_STANDARD=20    \
  -DLIBCXX_BUILD=<build-dir>
ninja -C build
# Your executable will be at /build
```

Here's [the Clang CI](.github/workflows/clang.yml) for your insight.

### MSVC

Specify the CMake variable `VCTOOLS_INSTALL_DIR`, which can be directly fetched 
via `$env:VCToolsInstallDir` in *x86 Native Tools Command Prompt for VS*, explained at [Microsoft documentation](https://learn.microsoft.com/en-us/cpp/cpp/tutorial-import-stl-named-module?view=msvc-170)
in detail.

```shell
cd <your-project-dir>
mkdir build
cmake -S . -B build -G "Visual Studio 17 2022" -T v143 `
  -DCMAKE_CXX_STANDARD=20                              `
  -DVCTOOLS_INSTALL_DIR="$env:VCToolsInstallDir"
cmake --build build -j4
# Your executable will be at build\Release
```

Here's [the MSVC CI](.github/workflows/msvc.yml) for your insight.