include ../l4t.mk

# flash前に作成されるイメージファイル
BOOT_IMG:=$(L4T_TOOL_DIR)/kernel_flash/images/external/boot.img
ETC_DIR:=$(L4T_ROOT_FS_DIR)/etc

# script
INITRD_SCRIPT:=./tools/kernel_flash/l4t_initrd_flash.sh
FILE_STORAGE:=./tools/kernel_flash/flash_l4t_external.xml

# QSPIの設定ファイル
ifeq ($(MAJOR),36)
	FILE_QSPI:=$(L4T_EXTRACT_DIR)/bootloader/generic/cfg/flash_t234_qspi.xml
else ifeq ($(MAJOR),35)
	FILE_QSPI:=$(L4T_EXTRACT_DIR)/bootloader/t186ref/cfg/flash_t234_qspi.xml
endif

# ------------------------------
# ユーザー設定
#

# ストレージデバイス
STORAGE_DEVIVE:=nvme0n1p1

# ボードの設定
BOARD:=jetson-orin-nano-devkit

# Need set your hostname
HOSTNAME?=orin-nano
USERNAME?=jetson
PASSWORD?=jetson

# ------------------------------

# CMD
FLASH_CMD:=sudo $(INITRD_SCRIPT) --external-device $(STORAGE_DEVIVE)\
	-c $(FILE_STORAGE)\
	-p "-c $(FILE_QSPI)"\
	--showlogs --network usb0

#
# ターゲットへのflash
#
.PHONY: flash
flash: $(BOOT_IMG)
	cd $(L4T_EXTRACT_DIR) \
	&& $(FLASH_CMD) --flash-only $(BOARD) internal

# L4Tにデフォルトユーザーを設定する
.PHONY: add_user
add_user:
	cd $(L4T_EXTRACT_DIR) \
	&& sudo ./tools/l4t_create_default_user.sh -u $(USERNAME) -p $(PASSWORD) --autologin --accept-license --hostname $(HOSTNAME)

# Imageファイルの作成
$(BOOT_IMG): $(ETC_DIR)
	cd $(L4T_EXTRACT_DIR) \
	&& $(FLASH_CMD) --no-flash $(BOARD) internal

#
# flashに必要なファイルの展開
#
.PHONY: extract	
extract: $(L4T_ROOT_FS_DIR)
	cd $(L4T_EXTRACT_DIR) \
		&& sudo ./apply_binaries.sh \
		&& sudo ./tools/l4t_flash_prerequisites.sh

# need for flash
setup:
	sudo apt install -y sshpass abootimg nfs-kernel-server libxml2-utils
