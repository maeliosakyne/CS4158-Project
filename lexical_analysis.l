%{
%}

%%
(?i:START) |
(?i:PRINT) |
(?i:MOVE) |
(?i:ADD) |
(?i:TO) |
(?i:INPUT) |
(?i:MAIN) |
(?i:END) {printf("%s is a valid keyword\n", yytext);}

\"(\\.|[^"\\])*\" {printf("%s is a string\n", yytext);}
[0-9]+ {printf("%s is a number\n", yytext);}

[Ss]+[ ] {printf("%s is a declaration\n", yytext);}
[_]?[A-Za-z][0-9A-Za-z-]* {printf("%s is an identifier\n", yytext);}

[;] {printf("%s is a string concatenator\n", yytext);}
[.] {printf("%s is a terminator\n", yytext);}
[\t ]+ {}

. {printf("unrecognised token %s\n", yytext);}
%%
 
int yywrap(){}
int main(){
 
yylex();
 
return 0;
}
