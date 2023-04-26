%{
#include <stdio.h>
#include "parser.tab.h"

int linenum = 1;
%}

%%
(?i:START) {return(KEY_START);}
(?i:PRINT) {return(KEY_PRINT);}
(?i:MOVE) {return(KEY_MOVE);}
(?i:ADD) {return(KEY_ADD);}
(?i:TO) {return(KEY_TO);}
(?i:INPUT) {return(KEY_INPUT);}
(?i:MAIN) {return(KEY_MAIN);}
(?i:END) {return(KEY_END);}

\"(\\.|[^"\\])*\" {printf("%s is a string\n", yytext);}

[0-9]+ {
		yylval.intValue = atoi(yytext);
		return(NUMBER); 
		}

[Ss]+[ ] {
			sscanf(yytext, "s", yylval.name);
			return(DECLARATION);}

[_]?[A-Za-z][0-9A-Za-z-]* {
							sscanf(yytext, "s", yylval.name);
							return(IDENTIFIER);
							}

[;] {return(CONCATENATOR);}
[.] {return(TERMINATOR);}

[\n] {linenum++;}
[\t ]+ {}

. {printf("unrecognised token %s\n", yytext);}
%%
 
int yywrap(){}
int main(){
 
yylex();
 
return 0;
}
