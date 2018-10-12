MAKE 	= 		make
GREP 	=		grep
AWK	=		awk
SORT	=		sort
PR 	=		pr

.DEFAULT: help
.PHONY: help
help:
	@$(MAKE) --print-data-base --question no-such-target | \
	$(GREP) -v -e '^no-such-target' -e '^makefile' | \
	$(AWK) '/^[^.%][-A-Za-z0-9_]*:/ { print substr($$1, 1, length($$1)-1) }' | \
	$(SORT)

all:
	echo "running all"

clean:
	echo "running clean"

dist:
	echo "running dist"
