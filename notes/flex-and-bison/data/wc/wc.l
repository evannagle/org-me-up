%{
int chars = 0;
int words = 0;
int lines = 0;
%}

%option noyywrap

%%

[a-zA-Z]+	{ words++; chars += strlen(yytext); }
\n		{ chars++; lines++; }
.		{ chars++; }

%%

int main(int argc, char **argv) {
	yylex();
	printf("chars:%8d\n", chars);
	printf("words:%8d\n", words);
	printf("lines:%8d\n", lines);
	return 0;
}
