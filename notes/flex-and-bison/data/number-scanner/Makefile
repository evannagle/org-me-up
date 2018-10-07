APP	=	number-scanner
LC	=	flex
LFLAGS	=
CC	=	gcc
CFLAGS	=	

all: $(APP)

lex.yy.c: $(APP).l
	$(LC) $(LFLAGS) $(APP).l

$(APP): lex.yy.c
	$(CC) $(CFLAGS) -o $(APP) lex.yy.c

clean:
	@rm -rf lex.yy.c $(APP)
