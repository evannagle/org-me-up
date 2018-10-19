# $(debug-enter)
WARN		:=	warning
COMMA		:=	,

debug-trace	=	1

echo-args	=	$(subst ' ','$(COMMA) ',\
				$(foreach a,1 2 3 4 5 6 7 8 9,'$($a)'))
debug-enter	=	$(if $(debug-trace),\
				$(warning Entering $0($(echo-args))))
debug-leave	=	$(if $(debug-trace),\
				$(warning leaving $0))
define a
	$(debug-enter)
	@echo $1 $2 $3
	$(debug-leave)
endef

define b
	$(debug-enter)
	$(call a,$1,$2,3)
	$(debug-leave)
endef

.PHONY: trace-macro

trace-macro:
	$(call b,1,2)
