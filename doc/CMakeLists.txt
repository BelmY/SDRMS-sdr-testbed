cmake_minimum_required(VERSION 2.8)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/CMakeModules")

project(documentation NONE)

include(UseLATEX)

add_latex_document(specification.tex)
