APP	=	cross-ref
LC	=	flex
LFLAGS	=
CC	=	gcc
CFLAGS	=	
BC	=	bison
BFLAGS	=	-d

all: $(APP)

lex.yy.c: $(APP).l
	$(LC) $(LFLAGS) $(APP).l

$(APP): lex.yy.c 
	$(CC) $(CFLAGS) -o $(APP) lex.yy.c -ll

clean:
	@rm -rf lex.yy.c $(APP)
