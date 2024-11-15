include ./l4t.mk

# 動作確認
.PHONY: check-vars
check-vars:
	@echo "L4T_VERSION: $(L4T_VERSION)"
	@echo "MAJOR: $(MAJOR)"
	@echo "MINOR: $(MINOR)"
	@echo "IS_JETSON: $(IS_JETSON)"
