NV_TEGRA_RELEASE_FILE?=/etc/nv_tegra_release

# Check if the system is a Jetson
ifneq ("$(wildcard $(NV_TEGRA_RELEASE_FILE))","")
	IS_JETSON:=true
	L4T_VERSION?=$(shell cat $(NV_TEGRA_RELEASE_FILE) | grep -o -E '^(\# R[0-9]+.+, REVISION: [0-9]+.[0-9]+)' | grep -o '[0-9]*' | head -c -1 | tr '\n' '.')
	MAJOR := $(shell echo ${L4T_VERSION} | grep -o -E '^([0-9]+)')
	MINOR := $(shell echo ${L4T_VERSION} | grep -o -E '([0-9]+)\.([0-9]+)$$')
else
	IS_JETSON:=false
# Default L4T version
	MAJOR?=36
	MINOR?=4.0
	L4T_VERSION?=${MAJOR}.${MINOR}
endif

# env
mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
PROJECT_DIR := $(patsubst %/,%,$(dir $(mkfile_path)))

# L4T download definition
L4T_BASE_URL:=https://developer.download.nvidia.com/embedded/L4T/r${MAJOR}_Release_v${MINOR}
RELEASE_ADDR:=${L4T_BASE_URL}/release
SOURCE_ADDR:=${L4T_BASE_URL}/sources

# bsp definition
L4T_RELEASE_PACKAGE:=Jetson_Linux_R${MAJOR}.${MINOR}_aarch64.tbz2
SAMPLE_FS_PACKAGE:=Tegra_Linux_Sample-Root-Filesystem_R${MAJOR}.${MINOR}_aarch64.tbz2

# extract definition
L4T_EXTRACT_DIR:=$(PROJECT_DIR)/Linux_for_Tegra
L4T_DL_DIR:=$(PROJECT_DIR)/downloads

L4T_TOOL_DIR:=$(L4T_EXTRACT_DIR)/tools
L4T_ROOT_FS_DIR:=$(L4T_EXTRACT_DIR)/rootfs
L4T_BSP_TBZ:=$(L4T_DL_DIR)/$(L4T_RELEASE_PACKAGE)
L4T_FS_TBZ:=$(L4T_DL_DIR)/$(SAMPLE_FS_PACKAGE)


# flashに必要なスクリプトの展開
$(L4T_TOOL_DIR): ${L4T_BSP_TBZ}
	tar xf ${L4T_BSP_TBZ} -C $(PROJECT_DIR) 
# 二回目の展開を防ぐためにtouch
	touch $(L4T_TOOL_DIR)

# rootfsの展開
$(L4T_ROOT_FS_DIR): $(L4T_TOOL_DIR) $(L4T_FS_TBZ)
	mkdir -p $(L4T_ROOT_FS_DIR)
	sudo tar xpf ${L4T_FS_TBZ} -C $(L4T_ROOT_FS_DIR)
# 二回目の展開を防ぐためにtouch
	touch $(L4T_ROOT_FS_DIR)

#
# L4T関係のダウンロード
#
.PHONY: download
download: ${L4T_BSP_TBZ} ${L4T_FS_TBZ}

$(L4T_BSP_TBZ):
	mkdir -p $(L4T_DL_DIR)
	wget -P $(L4T_DL_DIR) ${RELEASE_ADDR}/${L4T_RELEASE_PACKAGE}

$(L4T_FS_TBZ):
	mkdir -p $(L4T_DL_DIR)
	wget -P $(L4T_DL_DIR) ${RELEASE_ADDR}/${SAMPLE_FS_PACKAGE}
