LC	=	flex
LFLAGS	=
CC	=	gcc
CFLAGS	=	

all: colour

lex.yy.c: colour.l
	$(LC) $(LFLAGS) colour.l

colour: lex.yy.c
	$(CC) $(CFLAGS) -o colour lex.yy.c

clean:
	@rm -rf lex.yy.c colour
