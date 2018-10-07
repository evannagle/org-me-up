%{
#include "calculator.tab.h"
%}

%option noyywrap

%%

"+"    { return ADD; }
"-"    { return SUB; }
"*"    { return MUL; }
"/"    { return DIV; }
"|"    { return ABS; }
"\n"   { return EOL; }
"("    { return OP; }
")"    { return CP; }
"//".* /* ignore comments */

[0-9]+ { yylval = atoi(yytext); return NUMBER; }
[ \t]  { }
.      { printf("Mystery characters %c\n", *yytext); }

%%

			
