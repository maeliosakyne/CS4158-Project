%{
%}

%%
(?i:START) |
(?i:PRINT) |
(?i:MOVE) |
(?i:ADD) |
(?i:INPUT) |
(?i:MAIN) |
(?i:END) {printf("%s is a valid keyword\n", yytext);}

\"(\\.|[^"\\])*\" {printf("%s is a string\n", yytext);}
[0-9]+ {printf("%s is a number\n", yytext);}

[Ss]+[ ] {printf("%s is a declaration\n", yytext);}
[_A-Z][0-9A-Z-]* {printf("%s is an identifier\n", yytext);}

[;] {printf("%s is a string concatenator\n", yytext);}
[.] {printf("%s is a terminator\n", yytext);}
[\t ]+ {}
%%
 
int yywrap(){}
int main(){
 
yylex();
 
return 0;
}
