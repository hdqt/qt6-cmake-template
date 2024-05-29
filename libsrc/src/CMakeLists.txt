set(LIB_PRIVATE_SOURCES
    Dummy.cpp
    Dummy.hpp
)

if(BUILD_SHARED_LIBS)
    target_sources(${PROJECT_NAME} PRIVATE ${LIB_PRIVATE_SOURCES})
    target_include_directories(${PROJECT_NAME} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})
endif()

target_sources(lib${PROJECT_NAME} PRIVATE ${LIB_PRIVATE_SOURCES})
target_include_directories(lib${PROJECT_NAME} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})
