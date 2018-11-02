.PHONY: all

define after-hook1
	@echo "hook1($@)"
endef

define after-hook2
	@echo "hook2($@)"
endef

define after-hook3
	@echo "hook3($@)"
endef

define hook
	@echo "hook($@)"
	$(call after-hook,$@)
endef

target1: after-hook = $(after-hook1)
target1:
	$(call hook,$^)

target2: after-hook = $(after-hook2)
target2:
	$(call hook,$^)


target3: after-hook = $(after-hook$(TARGET))
target3:
	$(call hook,$^)
