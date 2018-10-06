%option noyywrap

%%

"colour" { printf("color"); }
. { printf("%s", yytext); }

%%

int main() {
  yylex();
  return 0;
}
