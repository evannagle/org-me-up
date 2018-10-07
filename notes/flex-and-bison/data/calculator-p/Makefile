APP	=	calculator
LC	=	flex
LFLAGS	=
CC	=	gcc
CFLAGS	=	
BC	=	bison
BFLAGS	=	-d

all: $(APP)

lex.yy.c: $(APP).l
	$(LC) $(LFLAGS) $(APP).l

$(APP).tab.h: $(APP).y
	$(BC) $(BFLAGS) -d $(APP).y

$(APP): lex.yy.c $(APP).tab.h
	$(CC) $(CFLAGS) -o $(APP) lex.yy.c $(APP).tab.c -ll

clean:
	@rm -rf lex.yy.c $(APP)
