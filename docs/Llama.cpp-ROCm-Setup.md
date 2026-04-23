# Building llama.cpp with ROCm Support

> **⚠️ IMPORTANT: Arch-Based Linux Only**  
> This project and all documentation are designed exclusively for **Arch-based Linux distributions** (e.g., Arch Linux, Manjaro, EndeavourOS).

This document provides a comprehensive guide on how to build llama.cpp with AMD ROCm support on a Linux system (Arch Linux based).

## 1. Prerequisites

### System Update and Basic Build Tools

Ensure the system is up to date and the necessary build tools are installed:

```bash
sudo pacman -Syu cmake ccache gcc
```

### Graphics Drivers

Install the required Vulkan and Mesa drivers for AMD GPUs:

```bash
sudo pacman -Syu vulkan-radeon lib32-vulkan-radeon mesa lib32-mesa
```

## 2. ROCm Installation

Install the ROCm SDKs and the ROCm WMA library:

```bash
sudo pacman -Syu rocm-hip-sdk rocm-opencl-sdk rocwmma
```

## 3. User Permissions

The user must be part of the `render` and `video` groups to access the GPU hardware:

```bash
sudo usermod -aG render,video $USER
```

*Note: You must log out and log back in for these group changes to take effect.*

## 4. Repository Setup

Clone the llama.cpp repository into your development directory:

```bash
git clone https://github.com/ggml-org/llama.cpp
cd llama.cpp
```

## 5. Build Process

### Configuration

Find your gpu version string by matching the most significant version information from
`rocminfo | grep gfx | head -1 | awk '{print $2}'` with the list of processors, e.g. gfx1035 maps to gfx1030.

The build uses CMake. It is critical to specify the correct HIP toolchain paths and target GPU architecture. For the GFX1201 architecture, use the following configuration:

```bash
rm -rf build
# Configure
HIPCXX="$(hipconfig -l)/clang" HIP_PATH="$(hipconfig -R)" cmake -B build \
    -DLLAMA_BUILD_EXAMPLES=OFF \
    -DLLAMA_BUILD_TESTS=OFF \
    -DGGML_HIP=ON \
    -DGGML_HIP_ROCWMMA_FATTN=ON \
    -DGGML_HIP_GRAPHS=ON \
    -DAMDGPU_TARGETS=gfx1201 \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_FLAGS="-march=native" \
    -DCMAKE_CXX_FLAGS="-march=native" \
    -DCMAKE_INTERPROCEDURAL_OPTIMIZATION=ON
# Build
cmake --build build --config Release -j "$(nproc)"
```

## 6. Installation

To make the binaries available system-wide, move them to a shared directory:

```bash
CACHE_DIR="/usr/local/share/llm"
sudo mkdir -p "${CACHE_DIR}/bin"
sudo chown -R $USER:$USER "${CACHE_DIR}"

cp build/bin/llama* "${CACHE_DIR}/bin/"
```

### Environment Configuration

Add the installation directory to your system PATH in `~/.bashrc` or `~/.zshrc`:

```bash
export PATH=/usr/local/share/llm/bin:$PATH
```

Then, reload the configuration:

```bash
source ~/.zshrc # or ~/.bashrc
```

## 7. Updating

To update llama.cpp to the latest version and rebuild the binaries:

```bash
# Update llama.cpp
cd llama.cpp
git pull
```

```bash
rm -rf build
# Configure
HIPCXX="$(hipconfig -l)/clang" HIP_PATH="$(hipconfig -R)" cmake -B build \
    -DLLAMA_BUILD_EXAMPLES=OFF \
    -DLLAMA_BUILD_TESTS=OFF \
    -DGGML_HIP=ON \
    -DGGML_HIP_ROCWMMA_FATTN=ON \
    -DGGML_HIP_GRAPHS=ON \
    -DAMDGPU_TARGETS=gfx1201 \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_FLAGS="-march=native" \
    -DCMAKE_CXX_FLAGS="-march=native" \
    -DCMAKE_INTERPROCEDURAL_OPTIMIZATION=ON
# Build
cmake --build build --config Release -j "$(nproc)"
```

```bash
# Re-install binaries
CACHE_DIR="/usr/local/share/llm"
cp build/bin/llama* "${CACHE_DIR}/bin/"
```

## 8. Enable firewall port 8080 on server

```bash
sudo firewall-cmd --zone=public --add-port=8080/tcp --permanent
sudo firewall-cmd --reload
```
