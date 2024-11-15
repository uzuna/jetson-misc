include ../l4t.mk

# perfソースファイルのあるディレクトリ
PERF_DIR:=$(KERNEL_DIR)/tools/perf

# pwerfのインストール先。
# 配置に影響するパラメータでビルド時に指定、dep.jsonにも記載
DESTDIR:=/opt/perf

# パッケージ名
PACKAGE_NAME:=$(shell cat deb.json | jq -r '.name')

.PHONY: deb
deb: build deb.json $(KERNEL_VERSION)
	@rm -rf $(DEB_DIR)/$(PACKAGE_NAME)*.deb
	@rm -rf pkg-build
	mkdir -p $(DEB_DIR)

	go-bin-deb generate -a arm64 --version $(shell cat $(KERNEL_VERSION)) --output $(DEB_DIR)

# build perf
.PHONY: build
build: $(KERNEL_DIR)
	prefix=$(DESTDIR) make -C $(PERF_DIR)

.PHONY: clean
clean:
	@rm -rf $(DEB_DIR)/$(PACKAGE_NAME)*.deb
	@rm -rf pkg-build
	@mkdir -p $(DEB_DIR)

# deb.jsonの生成。perfのディレクトリはソースによって変わる
deb.json: deb.template
	@awk '{gsub(/PERF_DIR/,"$(PERF_DIR)")}1' deb.template > deb.json
