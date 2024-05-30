# Qt6 CMake Template

This project implements all the basics for CMake and Conan Package Manager integration.
Other projects within this organization shall be inherited from this project as a base template.

## Features

- Basic structure with unit tests and mock
- Conan Package Manager integration through conanfile.py
- Support multiple development environments: Windows and Ubuntu

## Tested Environment

### Windows

- OS: Windows 11 Pro-64 bit

| Name | Version |
| ------ | ------ |
| Qt | 6.7.1 |
| CMake | 3.27.7 (install along with QtCreator) |
| Ninja | 1.10.2 (install along with QtCreator) |
| Conan | 2.3.2 |
| Python | 3.12.3 |
| Python pip | 24.0 |
| Perl | 5.38.2 |
| Android SDK | Default install by QtCreator |
| MingW | 11.2.0 (install along with QtCreator) |
| MSVC | 194 (install by Visual Studio Community 2022 |

### Ubuntu

- OS: Ubuntu 22.04 LTS (Jammy Jellyfish)

| Name | Version |
| ------ | ------ |
| Qt | 6.7.1 |
| CMake | 3.27.7 (install along with QtCreator) |
| Ninja | 1.10.2 (install along with QtCreator) |
| Conan | 2.3.2 |
| Python | 3.10.12 |
| Python pip | 24.0 |
| Perl | 5.34.0 |
| Android SDK | Default install by QtCreator |
| GCC | 11.4.0 |
