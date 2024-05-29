cmake_minimum_required(VERSION 3.14)

project(qt6-cmake-template LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_INCLUDE_CURRENT_DIR ON)

message(STATUS "CMAKE_SYSTEM_NAME: '${CMAKE_SYSTEM_NAME}'")
message(STATUS "CMAKE_MODULE_PATH: '${CMAKE_MODULE_PATH}'")
message(STATUS "CMAKE_PREFIX_PATH: '${CMAKE_PREFIX_PATH}'")

option(BUILD_UNIT_TESTS "Build Unit tests option" ON)
if(NOT CMAKE_SYSROOT)
    set(BUILD_UNIT_TESTS OFF CACHE BOOL "Disable unit test for non-native platform")
endif()

find_package(Qt6 REQUIRED COMPONENTS Quick)

add_subdirectory(libsrc)
