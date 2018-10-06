LC	=	flex
LFLAGS	=
CC	=	gcc
CFLAGS	=	

all: dumbers

lex.yy.c: dumbers.l
	$(LC) $(LFLAGS) dumbers.l

dumbers: lex.yy.c
	$(CC) $(CFLAGS) -o dumbers lex.yy.c

clean:
	@rm -rf lex.yy.c dumbers
