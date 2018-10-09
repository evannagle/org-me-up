APP	=	includer
LC	=	flex
LFLAGS	=
GC	=	gcc
GFLAGS	=	

all: $(APP)

lex.yy.c: $(APP).l
	$(LC) $(LFLAGS) $(APP).l

$(APP): lex.yy.c
	$(GC) $(GFLAGS) -o $(APP) lex.yy.c

clean:
	@rm -rf lex.yy.c $(APP)
