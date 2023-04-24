%{
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
[0-9]+ {printf("%s is a number\n", yytext);}

[Ss]+[ ] {printf("%s is a declaration\n", yytext);}
[_]?[A-Za-z][0-9A-Za-z-]* {printf("%s is an identifier\n", yytext);}

[;] {return(CONCATENATOR);}
[.] {return(TERMINATOR);}
[\t ]+ {}

. {printf("unrecognised token %s\n", yytext);}
%%
 
int yywrap(){}
int main(){
 
yylex();
 
return 0;
}
