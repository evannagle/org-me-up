define simple_function
 @echo "running 'simple_function' on $@..."
endef

define function_with_args
 @echo "running 'function_with_args' on $@..."
 @echo "-- variable: $(1)"
endef

.DEFAULT:	all
.PHONY:		all
all:
	$(simple_function)
	$(call function_with_args,"foo")
