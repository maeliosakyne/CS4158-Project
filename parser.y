/*** Definitions ***/
%{
#include <stdio.h> 
%}

%token KEY_START KEY_MAIN KEY_END KEY_PRINT KEY_MOVE KEY_ADD KEY_TO KEY_INPUT 
	TERMINATOR CONCATENATOR
	DECLARATION IDENTIFIER

%%
program: KEY_START TERMINATOR variable_declarations 
	MAIN TERMINATOR statement_list 
	KEY_END TERMINATOR
;
	
variable_declarations:
	| var_dec TERMINATOR variable_declarations
;

var_dec:
	DECLARATION IDENTIFIER {}
;

statement_list:
	| statement TERMINATOR statement_list
;

statement:
	KEY_ADD expression {}
	| KEY_MOVE expression {}
;

expression:
	NUMBER KEY_TO IDENTIFIER
	| IDENTIFIER KEY_TO IDENTIFIER
;
%%
