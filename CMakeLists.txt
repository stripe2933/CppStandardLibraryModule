cmake_minimum_required(VERSION 3.26 FATAL_ERROR)
project(CppStandardLibraryModule)

# --------------------
# Enable C++20 module support in CMake.
# You can omit this code when you're using CMake ≥ 3.28.
# --------------------

if (CMAKE_VERSION VERSION_LESS "3.28.0")
    if(CMAKE_VERSION VERSION_LESS "3.27.0")
        set(CMAKE_EXPERIMENTAL_CXX_MODULE_CMAKE_API "2182bf5c-ef0d-489a-91da-49dbc3090d2a")
    else()
        set(CMAKE_EXPERIMENTAL_CXX_MODULE_CMAKE_API "aa1f7df0-828a-4fcd-9afc-2dc80491aca7")
    endif()
    set(CMAKE_EXPERIMENTAL_CXX_MODULE_DYNDEP 1)
else()
    cmake_policy(VERSION 3.28)
endif()

# --------------------
# Include CMake scripts.
# --------------------

include(cmake/EnableStandardLibraryModule.cmake)

# --------------------
# Main executable.
# --------------------

add_executable(CppStandardLibraryModule main.cpp)