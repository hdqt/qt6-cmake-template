#!/usr/bin/bash

# Support machines
MACHINE_LINUX="Linux"
MACHINE_MINGW="Mingw"

# Conan profiles
# All of conan profiles with build_type=Release will be use to build package.
EXCLUDED_PROFILES=()    # Put the profiles which you do not want to build here
SINGLE_PROFILE=
BUILD_ALL=1

# 0. Get arguments
if [[ $# -ne 0 ]]; then
    while getopts 'e:s:a' flag; do
        case "${flag}" in
            e) EXCLUDED_PROFILES+=("${OPTARG}") ;;
            s) SINGLE_PROFILE="${OPTARG}" ;;
            a) BUILD_ALL=0 ;;
            *) break ;;
        esac
    done
else
    echo ""
    echo "Usage: ${BASH_SOURCE[0]} [-a] [-s PROFILE] [-e PROFILE [-e PROFILE]...]"
    echo ""
    echo "    -a                Create package for all profiles which has build_type=Release."
    echo "    -s PROFILE        Create package for a single PROFILE."
    echo "    -e PROFILE        Create package for all release profiles except PROFILE."
    echo "                      This option can be used multiple times."
    echo ""
    exit 0
fi

# 1. Check whether we are in Windows or Ubuntu
myos="$(uname -s)"
case "${myos}" in
    Linux*)
        MY_MACHINE=$MACHINE_LINUX
        ;;
    MINGW*)
        MY_MACHINE=$MACHINE_MINGW
        ;;
    *)
        echo "ERROR: Unsupport machine"
        exit 1
        ;;
esac
echo "Detect machine: $MY_MACHINE"

# 2. Get Conan executable
conan_version="$(conan --version | cut -d' ' -f3)"
status_code=$?
if [[ $status_code -ne 0 ]]; then
    echo "ERROR: Fail to find Conan executable. Install by command: python -m pip install conan"
    exit 1
else
    echo "Detect Conan version: $conan_version"
fi

# 3. Get project root dir
git_version="$(git --version | cut -d' ' -f3)"
status_code=$?
if [[ $status_code -eq 0 ]]; then
    PROJECT_ROOT_DIR="$(git rev-parse --show-toplevel)"
else
    # As default project structure, this directory is right below the project root directory
    this_dir="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"
    PROJECT_ROOT_DIR="$(dirname "$this_dir")"
fi
echo "PROJECT_ROOT_DIR: $PROJECT_ROOT_DIR"

# 4. Identify package name and version
CONANFILE_PATH="${PROJECT_ROOT_DIR}/conanfile.py"
if [[ ! -f "$CONANFILE_PATH" ]]; then
    echo "ERROR: Fail to find conanfile.py"
    exit 1
fi
PACKAGE_NAME="$(grep -E '^\s*name\s*=\s*"(.*)"$' "$CONANFILE_PATH" | awk 'BEGIN{FS="\""}{print $2}')"
PACKAGE_VERSION="$(grep -E '^\s*version\s*=\s*"(.*)"$' "$CONANFILE_PATH" | awk 'BEGIN{FS="\""}{print $2}')"
echo "PACKAGE_NAME   : $PACKAGE_NAME"
echo "PACKAGE_VERSION: $PACKAGE_VERSION"

# 5. Identify profiles to build
RELEASE_PROFILES=()
if [[ -z "$SINGLE_PROFILE" ]]; then
    all_profiles=($(conan profile list | grep -v 'Profiles found in the cache:' | grep -v 'default'))
    for profile in ${all_profiles[@]}; do
        # Remove excluded profiles
        if [[ ${#EXCLUDED_PROFILES[@]} -ne 0 ]]; then
            is_excluded=1
            for excluded_profile in ${EXCLUDED_PROFILES[@]}; do
                if [[ "$profile" == "$excluded_profile" ]]; then
                    is_excluded=0
                    break
                fi
            done

            if [[ $is_excluded -eq 0 ]]; then
                continue
            fi
        fi

        # Check if this is a release profile
        profile_build_type=$(conan profile show -pr:a "$profile" | sort -u | grep 'build_type' | cut -d'=' -f2)
        if [[ "$profile_build_type" == 'Release' ]]; then
            RELEASE_PROFILES+=($profile)
        fi
    done
else
    RELEASE_PROFILES+=($SINGLE_PROFILE)
fi

echo "Will build with ${#RELEASE_PROFILES[@]} release profiles:"
for profile in ${RELEASE_PROFILES[@]}; do
    echo "    $profile"
done

# 6. Build packages
declare -A build_status=()
for profile in ${RELEASE_PROFILES[@]}; do
    logfile_path="${log_dir}/${profile}_${today}.log"

    echo "Running: conan create \"$CONANFILE_PATH\" -pr \"$profile\" -o shared=True"
    conan create "$CONANFILE_PATH" -pr "$profile" -o shared=True
    status_code=$?
    if [[ $status_code -eq 0 ]]; then
        build_status[$profile]="SUCCESS"
    else
        build_status[$profile]="FAIL"
    fi
done

# 7. Show result and clean up
echo "Build results:"
for profile in ${!build_status[@]}; do
    echo "    $profile: ${build_status[$profile]}"
done
