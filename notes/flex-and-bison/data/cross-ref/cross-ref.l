%option noyywrap nodefault yylineno

%x COMMENT
%x IFILE

UCN (\\u[0-9a-fA-F]{4}|\\U[0-9a-fA-F]{8})
EXP ([Ee][-+]?[0-9]+)
ILEN ([Uu](L|l|LL|ll)?|(L|l|LL|ll)[Uu]?)

%{

char *curfilename;

/* the symbol table */
typedef struct refs {
    struct refs *next;
    char *filename;
    int flags;
    int lineno;
} Refs; 

typedef struct symbol {
    Refs *refs;
    char *name; 
} Symbol;

#define NHASH 9997

Symbol *get_symbol_by_name(char *name);
void add_symbol_reference(char *symbol_name, char *filename, int lineno, int flags);

typedef struct bufstack {
    struct bufstack *prev;
    YY_BUFFER_STATE bs;
    int lineno;
    char *filename;
    FILE *f;
} Buffers;

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

0[0-7]{ILEN}? /* integers */
[1-9][0-9]*{ILEN}?
0[Xx][0-9a-fA-F]+{ILEN}?

([0-9]*\.[0-9]+|[0-9]+\.){EXP}?[flFL]? /* decimal */

0[Xx]([0-9a-fA-F]*\.[0-9a-fA-F]+|[0-9a-fA-F]+\.?)[Pp][-+]?[0-9]+[flFL]? /* hex */

\'([^'\\]|\\['"?\\abfnrtv]|\\[0-7]{1,3}|\\[Xx][0-9A-Fa-f]+|{UCN})+\' /* char const */
L?\"([^"\\]|\\['"?\\abfnrtv]|\\[0-7]{1,3}|\\[Xx][0-9A-Fa-f]+|{UCN})+\" /* string literal */

"{"|"<%"|";" { defining = 0; }



%%

int main(int argc, char **argv) {
    return 0;
}
