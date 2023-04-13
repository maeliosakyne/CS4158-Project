/*** Definitions ***/
%{
#include <stdio.h> 
%}

%token KEYWORD DECLARATION IDENTIFIER

%%
program: START TERMINATOR statement_list END TERMINATOR;
%%
