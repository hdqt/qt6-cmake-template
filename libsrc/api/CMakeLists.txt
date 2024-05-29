set(LIB_PUBLIC_SOURCES
    IDummy.hpp
)

if (BUILD_SHARED_LIBS)
    target_sources(${PROJECT_NAME} PRIVATE ${LIB_PUBLIC_SOURCES})
    target_include_directories(${PROJECT_NAME} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
endif()

target_sources(lib${PROJECT_NAME} PRIVATE ${LIB_PUBLIC_SOURCES})
target_include_directories(lib${PROJECT_NAME} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
