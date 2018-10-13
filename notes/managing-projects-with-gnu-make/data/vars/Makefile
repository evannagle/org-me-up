FOO	:=	bar
FOO	?=	qux

.PHONY: whats-foo
whats-foo:
	@echo "$(FOO)"

GLUE	=	a
GLUE	+=	b

.PHONY: whats-glue
whats-glue:
	@echo "$(GLUE)"

GLUE2	=	$(GLUE) c

.PHONY: whats-glue2
whats-glue2:
	@echo "$(GLUE2)"
