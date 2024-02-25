# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(piper_tts_library VERSION 0.0.1 LANGUAGES C)

add_library(piper_tts SHARED
  "piper_tts.c"
)

set_target_properties(piper_tts PROPERTIES
  PUBLIC_HEADER piper_tts.h
  OUTPUT_NAME "piper_tts"
)

target_compile_definitions(piper_tts PUBLIC DART_SHARED_LIB)
