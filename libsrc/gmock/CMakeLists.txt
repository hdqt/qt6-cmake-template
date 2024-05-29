add_library(${PROJECT_NAME}-gmock SHARED)
target_link_libraries(${PROJECT_NAME}-gmock PUBLIC lib${PROJECT_NAME})

set(MOCK_PUBLIC_SOURCES
    MockIDummy.hpp
)

target_sources(${PROJECT_NAME}-gmock PRIVATE ${MOCK_PUBLIC_SOURCES})
target_include_directories(${PROJECT_NAME}-gmock PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
