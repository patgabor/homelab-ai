# AMD ROCm GPU Health Check

> **⚠️ IMPORTANT: Arch-Based Linux Only**
> This project and all documentation are designed exclusively for **Arch-based Linux distributions** (e.g., Arch Linux, Manjaro, EndeavourOS). Other distributions are not supported.

A reference guide for verifying AMD GPU and ROCm setup on Arch Linux. Each command checks a specific aspect of the hardware and driver stack.

## Commands

### 1. List GPU hardware

```bash
lspci | grep -E "VGA|3D"
```

Lists all VGA-compatible and 3D controllers detected by the system. Confirms the GPU is physically present and recognized by the kernel.

### 2. PCIe link capabilities and status

```bash
sudo lspci -vv -s 03:00.0 | grep -E "LnkCap|LnkSta"
```

Shows the PCIe link capabilities (`LnkCap`) and current link status (`LnkSta`) - speed and width (e.g., Gen5 x16). Ensures the GPU is operating at full bandwidth.

### 3. OpenGL hardware acceleration

```bash
glxinfo | grep "OpenGL renderer"
```

Verifies that OpenGL rendering is hardware-accelerated via the GPU driver. A good result shows the AMD Radeon GPU name rather than "llvmpipe" (software fallback).

### 4. Vulkan device detection

```bash
vulkaninfo | grep "deviceName"
```

Confirms Vulkan can enumerate the GPU. Expected output includes the R9700 and possibly the CPU's integrated GPU:

```txt
deviceName        = AMD Radeon AI PRO R9700 (RADV GFX1201)
deviceName        = AMD Ryzen 9 9900X3D 12-Core Processor (RADV RAPHAEL_MENDOCINO)
```

A warning `radv is not a conformant Vulkan implementation, testing use only` is normal and expected for the RADV open-source driver.

### 5. Resizable BAR (Smart Access Memory)

```bash
sudo lspci -vv -s 03:00.0 | grep -i bar
```

Checks whether Resizable BAR is enabled. Expected: `Capabilities: [200 v1] Physical Resizable BAR ...`. This feature allows the CPU to access the full GPU memory range, which is critical for ROCm performance.

### 6. OpenGL driver version

```bash
glxinfo | grep "OpenGL version"
```

Shows the Mesa driver version. For modern GPUs like the R9700, you want Mesa 25.x or newer for full ROCm and Vulkan support.

### 7. ROCm version

```bash
cat /opt/rocm/.info/version
```

Displays the installed ROCm toolkit version. Confirms the ROCm SDK is properly installed and accessible.
