%option noyywrap nodefault yylineno

%x COMMENT
%x IFILE

UCN (\\u[0-9a-fA-F]{4}|\\U[0-9a-fA-F]{8})
EXP ([Ee][-+]?[0-9]+)
ILEN ([Uu](L|l|LL|ll)?|(L|l|LL|ll)[Uu]?)

%{

char *curfilename;
int newfile(char *fn);
int popfile(void);
void addref(int, char*, char*, int);
void printrefs();

struct bufstack {
    struct bufstack *prev;
    YY_BUFFER_STATE bs;
    int lineno;
    char *filename;
    FILE *f;
} *curbs = 0;

struct symbol {
	char *name;
	struct ref *reflist;
};

struct ref {
	struct ref *next;
	char *filename;
	int flags;
	int lineno;
};

#define NHASH 9997
struct symbol symtab[NHASH];

int add_file_to_stack(char *filename);
int pop_file_from_stack();
int defining;

%}

%%

"/*" { BEGIN(COMMENT); }
<COMMENT>"*/" { BEGIN(INITIAL); }
<COMMENT>([^*]|\n)+|.
<COMMENT><<EOF>> {
    printf("%s:%d: Unterminated comment\n", curfilename, yylineno);
    return 0;
}

{UCN}

"//".*\n

_Bool |
_Complex |
_Imaginary |
auto |
char |
const |
double |
enum |
extern |
float |
inline |
int |
long |
register |
restrict |
short |
signed |
static |
struct |
typedef |
union |
unsigned |
void |
volatile { defining = 1; }

break
case
continue
default
do
else
for
goto
if
return
sizeof
switch
while

0[0-7]*{ILEN}? /* integers */
[1-9][0-9]*{ILEN}?
0[Xx][0-9a-fA-F]+{ILEN}?

([0-9]*\.[0-9]+|[0-9]+\.){EXP}?[flFL]? /* decimal */

0[Xx]([0-9a-fA-F]*\.[0-9a-fA-F]+|[0-9a-fA-F]+\.?)[Pp][-+]?[0-9]+[flFL]? /* hex */

\'([^'\\]|\\['"?\\abfnrtv]|\\[0-7]{1,3}|\\[Xx][0-9A-Fa-f]+|{UCN})+\' /* char const */
L?\"([^"\\]|\\['"?\\abfnrtv]|\\[0-7]{1,3}|\\[Xx][0-9A-Fa-f]+|{UCN})+\" /* string literal */

"{"|"<%"|";" { defining = 0; } /* punctuators */

"["|"]"|"("|")"|"{"|"}"|"."|"->"|"++"|"--"|"\\"|"&"|"*"|"+"|"-"|"~"|"!"|"/"|"%"|"<<"|">>"|"<"|">"|"<="|">="|"=="|"!="|"^"|"|"|"&&"|"||" /* punctuators */
"?"|":"|";"|"..."|"="|"*="|"/="|"%="|"+="|"-="|"<<="|">>="|"&="|"^="|"|="|","|"#"|"##"|"<:"|":>"|"%>"|"%:"|"%:%:"|"\""

([_a-zA-Z]|{UCN})([_a-zA-Z0-9]|{UCN})* {
    addref(yylineno, curfilename, yytext, defining);
}

[ \t\n]+ /* whitespace */

\\$ /* continued line */

"#"" "*if.*\n
"#"" "*else.*\n
"#"" "*endif.*\n
"#"" "*define.*\n
"#"" "*line.*\n

^"#"[ \t]*include[ \t]*[\"<] { BEGIN IFILE; }
<IFILE>[^>\"]+ { 
    { int c; while((c = input()) && c != '\n'); }
    newfile(strdup(yytext));
    BEGIN INITIAL;
}

<IFILE>.|\n {
    fprintf(stderr, "%s:%d bad include line\n", curfilename, yylineno);
    BEGIN INITIAL;
}

<<EOF>> { if(!popfile()) yyterminate(); }

. {
    printf("%s:%d: Mystery character '%s'\n", curfilename, yylineno, yytext);
}

%%

//"
int main(int argc, char **argv) {
    int i;

    if(argc < 2) {
      fprintf(stderr, "need filename\n");
      return 1;
    }

    for(i = 1; i < argc; i++) {
      if(newfile(argv[i])) yylex();
    }

    printrefs();
    return 0;
}

static unsigned symhash(char *sym) {
    unsigned int hash = 0;
    unsigned c;
    while(( c = *sym++ )) hash = hash*9 ^ c;
    return hash;
}

struct symbol *lookup(char *sym) {
    struct symbol *sp = &symtab[symhash(sym)%NHASH];
    int scount = NHASH;
    while(--scount) {
	if(sp->name && !strcasecmp(sp->name, sym)) return sp;
	if(!sp->name) {
	    sp->name = strdup(sym);
	    sp->reflist = 0;
	    return sp;
	}

	if(++sp >= symtab+NHASH) sp = symtab;
    }
    fputs("symbol table overflow\n", stderr);
    abort(); 
}

void addref(int lineno, char *filename, char *word, int flags) {
    //printf("Adding ref: %s:%s\n", filename, word);

    struct ref *r;
    struct symbol *sp = lookup(word);
    if(sp->reflist && sp->reflist->lineno == lineno && sp->reflist->filename == filename) return;

    r = malloc(sizeof(struct ref));
    if(!r) {
	fputs("out of space\n", stderr);
	abort();
    }
    r->next = sp->reflist;
    r->filename = filename;
    r->lineno = lineno;
    r->flags = flags;
    sp->reflist = r;
}

static int symcompare(const void *xa, const void *xb) {
    const struct symbol *a = xa;
    const struct symbol *b = xb;
    if(!a->name) {
	if(!b->name) return 0;
	return 1;
    }
    if(!b->name) return -1;
    return strcmp(a->name, b->name);
}

void printrefs() {
    struct symbol *sp;
    qsort(symtab, NHASH, sizeof(struct symbol), symcompare);
    for(sp = symtab; sp->name && sp < symtab+NHASH; sp++) {
	char *prevfn = NULL;

	struct ref *rp = sp->reflist;
	struct ref *rpp = 0;
	struct ref *rpn;

	do {
	    rpn = rp->next;
	    rp->next = rpp;
	    rpp = rp;
	    rp = rpn;
	} while(rp);

	printf("%20s", sp->name);
	for(rp = rpp; rp; rp = rp->next) {
            if(rp->filename == prevfn) {
                printf(" %d", rp->lineno );
            } else {
                printf(" %s:%d", rp->filename, rp->lineno);
                prevfn = rp->filename;
            }
            if(rp->flags & 01) printf("*");
	}
        printf("\n");
    }
}

int newfile(char *fn) {
  FILE *f = fopen(fn, "r");
  struct bufstack *bs = malloc(sizeof(struct bufstack));

  if(!f) { perror(fn); return 0; }
  if(!bs) { perror("malloc"); exit(1); }

  if(curbs) curbs->lineno = yylineno;
  bs->prev = curbs;
  bs->bs = yy_create_buffer(f, YY_BUF_SIZE);
  bs->f = f;
  bs->filename = strdup(fn);
  yy_switch_to_buffer(bs->bs);
  curbs = bs;
  yylineno = 1;
  curfilename = bs->filename;
  return 1;
}

int popfile(void) {
  struct bufstack *bs = curbs;
  struct bufstack *prevbs;

  if(!bs) return 0;
  fclose(bs->f);
  free(bs->filename);
  yy_delete_buffer(bs->bs);
  prevbs = bs->prev;
  free(bs);
  if(!prevbs) return 0;
  yy_switch_to_buffer(prevbs->bs);
  curbs = prevbs;
  yylineno = curbs->lineno;
  curfilename = curbs->filename;
  return 1;
}
