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
PWD:=$(shell pwd)
