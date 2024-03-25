# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

# Project-level configuration.
set(PROJECT_NAME "piper_tts")
project(${PROJECT_NAME} LANGUAGES CXX)

# Read from local.properties
file(READ "${CMAKE_CURRENT_SOURCE_DIR}/local.properties" ndkProperties)
string(REGEX MATCH "ndk.dir=(.*)\n" ndkDir "${ndkProperties}")
set(ANDROID_NDK "${CMAKE_MATCH_1}")
message(STATUS "NDK directory: ${ANDROID_NDK}")

if(NOT ANDROID_NDK)
  message(FATAL_ERROR "NDK directory not found in local.properties.")
endif()

# Invoke the build for native code shared with the other target platforms.
# This can be changed to accommodate different builds.
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/../src/piper" "${CMAKE_CURRENT_BINARY_DIR}/shared")

# List of absolute paths to libraries that should be bundled with the plugin.
# This list could contain prebuilt libraries, or libraries created by an
# external build triggered from this build file.
set(piper_tts_bundled_libraries
  # Defined in ../src/CMakeLists.txt.
  # This can be changed to accommodate different builds.
  $<TARGET_FILE:piper>
  PARENT_SCOPE
)