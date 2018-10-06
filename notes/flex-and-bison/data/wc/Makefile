LC	=	flex
LFLAGS	=
GC	=	gcc
GFLAGS	=	

all: wc

lex.yy.c: wc.l
	$(LC) $(LFLAGS) wc.l

wc: lex.yy.c
	$(GC) $(GFLAGS) -o wc lex.yy.c

clean:
	@rm -rf lex.yy.c wc
