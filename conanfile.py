from conan import ConanFile
from conan.tools.cmake import cmake_layout, CMakeDeps, CMakeToolchain, CMake

class Qt6CmakeTemplate(ConanFile):
    name = "qt6-cmake-template"
    version = "1.0.0"
    license = "MIT"
    author = "Dang Nguyen nguyenhaidang911@gmail.com"
    url = "https://github.com/hdqt/qt6-cmake-template.git"
    settings = "os", "arch", "compiler", "build_type"
    options = {
        "shared": [True, False]
    }
    default_options = {
        "shared": False
    }
    exports_sources = ["!build/*", "*CMakeLists.txt", "*.cmake", "conanfile.py",
                      "*.cpp", "*.hpp"]

    def requirements(self):
        if self.buildenv.vars(self).get("PLATFORM") == "Native":
            self.requires("gtest/1.14.0")

    def layout(self):
        cmake_layout(self)

    def generate(self):
        deps = CMakeDeps(self)
        deps.generate()
        tc = CMakeToolchain(self)
        tc.variables["SKIP_BUILD_UNIT_TESTS"] = self.buildenv.vars(self).get("PLATFORM") != "Native"
        tc.variables["CONAN_QT_DIR"] = self.buildenv.vars(self).get("QT_DIR", "")
        tc.generate()

    def build(self):
        cmake = CMake(self)
        cmake.configure()
        cmake.build()

    def package(self):
        cmake = CMake(self)
        cmake.install()

    def package_info(self):
        self.cpp_info.libs = [self.name]
