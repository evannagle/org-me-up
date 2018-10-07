%{
int chars = 0;
int words = 0;
int lines = 0;

int total_chars = 0;
int total_words = 0;
int total_lines = 0;

%}

%option noyywrap
			
%%

[a-zA-Z]+   { words++; chars += strlen(yytext); }
\n          { chars++; lines++; }
.           { chars++; }

%%

int main(int argc, char **argv) {
    int i;
    
    if(argc < 2) {
	yylex();
	printf("chars:%8d\n", chars);
	printf("words:%8d\n", words);
	printf("lines:%8d\n", lines);
	return 0;
    }

    for(i = 1; i < argc; i++) {
	FILE *f = fopen(argv[i], "r");
	if(!f) {
	    perror(argv[i]);
	    return (1);
	}
	yyrestart(f);
	yylex();
	fclose(f);
	printf("%-40s%8d%8d%8d\n", argv[i], chars, words, lines);
	total_chars += chars;
	total_words += words;
	total_lines += lines;
    }
    if(total_chars) {
	printf("%-40s%8d%8d%8d\n", "*TOTAL*", total_chars, total_words, total_lines);
    }
}
