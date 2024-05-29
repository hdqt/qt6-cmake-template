cmake_minimum_required(VERSION 3.14)

set(QT_CREATOR_SKIP_CONAN_SETUP ON)

project(qt6-cmake-template LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_INCLUDE_CURRENT_DIR ON)

include(cmake/conan-setup.cmake)

option(BUILD_UNIT_TESTS "Build Unit tests option" ON)
if (SKIP_BUILD_UNIT_TESTS)
    set(BUILD_UNIT_TESTS OFF CACHE BOOL "Disable Unit tests due to non-native platform" FORCE)
endif()

find_package(Qt6 REQUIRED COMPONENTS Quick)

if (BUILD_UNIT_TESTS)
    find_package(GTest)
endif()

add_subdirectory(libsrc)
