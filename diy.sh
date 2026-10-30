#!/bin/bash
#=================================================
# Description: DIY script for G-DOCK (R619AC)
#=================================================

# 1. 修改默认主机名
sed -i 's/OpenWrt/G-DOCK/g' package/base-files/files/bin/config_generate

# 2. 修改时区为中国标准时间 (CST-8)
sed -i "s/'UTC'/'CST-8'\n        set system.@system[-1].zonename='Asia\/Shanghai'/g" package/base-files/files/bin/config_generate

# 3. 替换/设置自定义 Banner（若根目录存在 banner 文件）
if [ -f "../banner" ]; then
    rm -rf package/base-files/files/etc/banner
    cp -f ../banner package/base-files/files/etc/
fi

# 4. 修复 dwarves 与 CMake 语法兼容
mkdir -p tools/dwarves/patches
cat > tools/dwarves/patches/001-cmake-minimum-version.patch <<'EOF'
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -1 +1 @@
-cmake_minimum_required(VERSION 2.8.12)
+cmake_minimum_required(VERSION 3.5)
EOF
