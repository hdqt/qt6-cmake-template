macro(choose_host_profile)
    detect_os(MYOS MYOS_API_LEVEL MYOS_SDK MYOS_SUBSYSTEM MYOS_VERSION)
    detect_arch(MYARCH)
    detect_compiler(MYCOMPILER MYCOMPILER_VERSION MYCOMPILER_RUNTIME MYCOMPILER_RUNTIME_TYPE)
    detect_cxx_standard(MYCXX_STANDARD)
    detect_lib_cxx(MYLIB_CXX)
    detect_build_type(MYBUILD_TYPE)
    set(_CONAN_HOST_PROFILE "${MYOS}-${MYARCH}-${MYCOMPILER}-${MYCOMPILER_VERSION}-${MYBUILD_TYPE}")
    string(TOLOWER ${_CONAN_HOST_PROFILE} CONAN_HOST_PROFILE)
    message(STATUS "Conan-Setup: Host profile '${CONAN_HOST_PROFILE}'")

    execute_process(COMMAND ${CONAN_COMMAND} profile path ${CONAN_HOST_PROFILE}
                    RESULT_VARIABLE result_code)
    if (NOT result_code EQUAL 0)
        detect_host_profile(${CMAKE_BINARY_DIR}/conan-dependencies/profile)
        message(FATAL_ERROR "Conan-Setup: Profile '${CONAN_HOST_PROFILE}' does not exist. Fallback to default profile")
    endif()
endmacro()

macro(auto_setup_conan)
    find_program(conan_program conan)
    if (NOT conan_program)
        message(FATAL_ERROR "Conan-Setup: Conan executable not found.")
        return()
    else()
        message(STATUS "Conan-Setup: Conan executable: '${conan_program}'")
    endif()

    execute_process(COMMAND ${conan_program} --version
                    RESULT_VARIABLE result_code
                    OUTPUT_VARIABLE conan_version_output
                    ERROR_VARIABLE conan_version_output)
    if (NOT result_code EQUAL 0)
        message(FATAL_ERROR "Conan-Setup: conan --version failed='${result_code}: ${conan_version_output}")
    endif()

    string(REGEX REPLACE ".*Conan version ([0-9].[0-9]).*" "\\1" conan_version "${conan_version_output}")
    message(STATUS "Conan-Setup: Conan version: '${conan_version}'")

    include(${CMAKE_CURRENT_LIST_DIR}/conan_provider.cmake)

    if (${conan_version} VERSION_GREATER_EQUAL 2.0)
        set(CONAN_COMMAND "${conan_program}")
        choose_host_profile()
        conan_install(-pr "${CONAN_HOST_PROFILE}" --build=missing
                      --output-folder "${CMAKE_BINARY_DIR}/conan-dependencies")

        get_property(CONAN_INSTALL_SUCCESS GLOBAL PROPERTY CONAN_INSTALL_SUCCESS)
        if (CONAN_INSTALL_SUCCESS)
            get_property(CONAN_GENERATORS_FOLDER GLOBAL PROPERTY CONAN_GENERATORS_FOLDER)
            file(TO_CMAKE_PATH "${CONAN_GENERATORS_FOLDER}" CONAN_GENERATORS_FOLDER)

            set(conan_paths_content "")
            string(APPEND conan_paths_content "list(PREPEND CMAKE_PREFIX_PATH \"\${CONAN_GENERATORS_FOLDER}\")\n")
            string(APPEND conan_paths_content "list(PREPEND CMAKE_MODULE_PATH \"\${CONAN_GENERATORS_FOLDER}\")\n")
            string(APPEND conan_paths_content "list(PREPEND CMAKE_FIND_ROOT_PATH \"\${CONAN_GENERATORS_FOLDER}\")\n")
            string(APPEND conan_paths_content "list(REMOVE_DUPLICATES CMAKE_PREFIX_PATH)\n")
            string(APPEND conan_paths_content "list(REMOVE_DUPLICATES CMAKE_MODULE_PATH)\n")
            string(APPEND conan_paths_content "list(REMOVE_DUPLICATES CMAKE_FIND_ROOT_PATH)\n")
            string(APPEND conan_paths_content "set(CMAKE_PREFIX_PATH \"\${CMAKE_PREFIX_PATH}\" CACHE STRING \"\" FORCE)\n")
            string(APPEND conan_paths_content "set(CMAKE_MODULE_PATH \"\${CMAKE_MODULE_PATH}\" CACHE STRING \"\" FORCE)\n")
            string(APPEND conan_paths_content "set(CMAKE_FIND_ROOT_PATH \"\${CMAKE_FIND_ROOT_PATH}\" CACHE STRING \"\" FORCE)\n")
            string(APPEND conan_paths_content "\n")
            file(WRITE "${CMAKE_BINARY_DIR}/conan-dependencies/conan_paths.cmake" "${conan_paths_content}")
            unset(conan_paths_content)

            include("${CMAKE_BINARY_DIR}/conan-dependencies/conan_paths.cmake")
            include("${CONAN_GENERATORS_FOLDER}/conan_toolchain.cmake")
        endif()
    endif()
endmacro()
auto_setup_conan()
