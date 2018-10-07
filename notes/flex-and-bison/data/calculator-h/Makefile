APP	=	calculator
LC	=	flex
LFLAGS	=
CC	=	gcc
CFLAGS	=	
BC	=	bison
BFLAGS	=	-d
LEXF	=	clex.c

all: $(APP)

$(APP).tab.h: $(APP).y
	$(BC) $(BFLAGS) $(APP).y

$(APP): $(LEXF) $(APP).tab.h
	$(CC) $(CFLAGS) -o $(APP) $(LEXF) $(APP).tab.c -ll

clean:
	@rm -rf lex.yy.c $(APP)
