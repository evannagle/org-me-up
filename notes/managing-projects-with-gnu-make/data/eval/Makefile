#$(call program-variables,variable-prefix,file-list)
define program-variables
$(eval $1_sources = $(filter %.c,$2))
$(eval $1_headers = $(filter %.h,$2))
$(eval $1_objects = $(subst .c,.o,$(filter %.c,$2)))

programs += $1

$1: $($1_objects)

$($1_objects): $($1_headers)
endef

all:

$(eval $(call program-variables,ls,ls.c,ls.h.glob.c,glob.h))

all: $(programs)

clean:
	rm -rf $(programs)
	rm -rf *.o
