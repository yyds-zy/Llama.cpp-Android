# For more information about using CMake with Android Studio, read the
# documentation: https://d.android.com/studio/projects/add-native-code.html.
# For more examples on how to use CMake, see https://github.com/android/ndk-samples.

# 指定了这个项目需要的 CMake 的最低版本是 3.22.1。这意味着项目使用了在 3.22.1 版本中引入的一些特性，并且需要至少这个版本的 CMake 来构建。
cmake_minimum_required(VERSION 3.22.1)

# project("llama-android") 定义了项目的名称为 "llama-android"。
# 这会设置 CMAKE_PROJECT_NAME 变量为 "llama-android"
project("llama-android")

#include(FetchContent)
#FetchContent_Declare(
#        llama
#        GIT_REPOSITORY https://github.com/ggerganov/llama.cpp
#        GIT_TAG        master
#)

# Also provides "common"
#FetchContent_MakeAvailable(llama)

# Creates and names a library, sets it as either STATIC
# or SHARED, and provides the relative paths to its source code.
# You can define multiple libraries, and CMake builds them for you.
# Gradle automatically packages shared libraries with your APK.
#
# In this top level CMakeLists.txt, ${CMAKE_PROJECT_NAME} is used to define
# the target library name; in the sub-module's CMakeLists.txt, ${PROJECT_NAME}
# is preferred for the same purpose.
#

#load local llama.cpp
# 将 CMake 的构建目录指向了相对于当前 CMakeLists.txt 文件的相对路径下的 build-llama 目录。
# 这意味着 CMake 会在指定的目录中查找 CMakeLists.txt 文件，并使用它来构建项目。这通常用于构建第三方库或子项目。
add_subdirectory(../../../../../../ build-llama)

# In order to load a library into your app from Java/Kotlin, you must call
# System.loadLibrary() and pass the name of the library defined here;
# for GameActivity/NativeActivity derived applications, the same library name must be
# used in the AndroidManifest.xml file.
add_library(${CMAKE_PROJECT_NAME} SHARED
        # List C/C++ source files with relative paths to this CMakeLists.txt.
        llama-android.cpp)

# Specifies libraries CMake should link to your target library. You
# can link libraries from various origins, such as libraries defined in this
# build script, prebuilt third-party libraries, or Android system libraries.
# build-llama 目录中有一个 CMakeLists.txt 文件，它负责定义如何构建 llama 和 common 库。
# 此外，android 和 log 库是 Android NDK 中的标准库，通常用于 Android 应用开发。
target_link_libraries(${CMAKE_PROJECT_NAME}
        # List libraries link to the target library
        llama
        common
        android
        log)
