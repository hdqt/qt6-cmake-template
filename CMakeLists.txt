cmake_minimum_required(VERSION 3.18)

set(QT_CREATOR_SKIP_CONAN_SETUP ON)

project(qt6-cmake-template LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_INCLUDE_CURRENT_DIR ON)

if (QT_CREATOR_SKIP_CONAN_SETUP)
    include(cmake/conan-setup.cmake)
endif()

option(BUILD_UNIT_TESTS "Build Unit tests option" ON)
if (SKIP_BUILD_UNIT_TESTS)
    set(BUILD_UNIT_TESTS OFF CACHE BOOL "Disable Unit tests due to non-native platform" FORCE)
endif()

if ("${Qt6_DIR}" STREQUAL "")
    list(PREPEND CMAKE_PREFIX_PATH "${CONAN_QT_DIR}")
    list(REMOVE_DUPLICATES CMAKE_PREFIX_PATH)
    set(CMAKE_PREFIX_PATH "${CMAKE_PREFIX_PATH}" CACHE STRING "" FORCE)
endif()

find_package(Qt6 REQUIRED COMPONENTS Quick)

if (BUILD_UNIT_TESTS)
    find_package(GTest)
endif()

add_subdirectory(libsrc)

include(GNUInstallDirs)

if(BUILD_SHARED_LIBS)
    install(TARGETS ${PROJECT_NAME}
        LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    )
endif()

install(TARGETS lib${PROJECT_NAME}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
