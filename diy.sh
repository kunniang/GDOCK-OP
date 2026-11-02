#!/bin/bash
#=================================================
# Description: DIY script for G-DOCK (R619AC)
# 注意：本脚本只做「源码树内的配置修改」，必须在 feeds 更新之前执行。
#       passwall 的引入已移到 workflow 中（feeds 清理之后），见 build-gdock.yml。
#=================================================
set -e

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

# 5. 清理 feeds.conf.default 中可能残留的 passwall 行（防止干扰）
sed -i '/passwall/d' feeds.conf.default

# 6. 提示：passwall 主程序与依赖包已迁库
#    原 xiaorouji/openwrt-passwall 已 404（迁至 Openwrt-Passwall 组织），
#    因此改由 workflow 在 feeds 装好、重复包清理完成后再 clone，避免与 feeds 版本冲突。
echo "diy.sh done (passwall 由 workflow 后置引入)"
