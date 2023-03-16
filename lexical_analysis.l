%{
%}

%%
(?i:START) {printf("program start\n");}
(?i:PRINT) {printf("print statement\n");}
(?i:MOVE) {printf("move statement\n");}
(?i:ADD) {printf("add statement\n");}
(?i:INPUT) {printf("input statement\n");}
(?i:MAIN) {printf("main statement\n");}
(?i:END) {printf("program end\n");}

\"(\\.|[^"\\])*\" {printf("%s is a string\n", yytext);}
[0-9]+ {printf("%s is a number\n", yytext);}

[Ss]+[ ] {printf("%s is a declaration\n", yytext);}
[_A-Z][0-9A-Z-]* {printf("%s is an identifier\n", yytext);}

; {}
.\n {}
[\t ]+ {}
%%
 
int yywrap(){}
int main(){
 
yylex();
 
return 0;
}
