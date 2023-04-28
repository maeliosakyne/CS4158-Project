/*** Definitions ***/
%{
#include <stdio.h>
#include <string.h>

extern int linenum;
int yylex();

int search(char name[]);
void insertVar(char name[], int size, char value[]);
void insertVal(char value[], int posi);

int yyerror(char *s);
void yyerror2(int type, char *s, char b[]);

struct symtab{
	char name[20];
	int size;
	char value[20];
};

struct symtab tab[20];
int ptr = 0;
%}

%token KEY_START KEY_MAIN KEY_END KEY_PRINT KEY_MOVE KEY_ADD KEY_TO KEY_INPUT 
	TERMINATOR CONCATENATOR
	DECLARATION IDENTIFIER
%token <variable> NUMBER

%union {
	char name[20];
	int intValue;
	char *output_item;
}


%type <name> IDENTIFIER
%type <name> DECLARATION
%type <list> input_list
%type <list> output_list
%type <variable> NUMBER
%type <output_item> output_item
%type <variable_list> variable_declarations



%%

program: KEY_START TERMINATOR variable_declarations 
	KEY_MAIN TERMINATOR statement_list 
	KEY_END TERMINATOR
;
	
variable_declarations:
	| var_dec TERMINATOR variable_declarations
;

var_dec:
	DECLARATION IDENTIFIER {
		int flag;
		flag = search($2);
		
			if(flag == -1){
        int size = strlen($2);
        insertVar($2, size, "0");
    }else{
        char *t = "Identifier already defined - ";
        yyerror2(3,t, $2);
    }
}
;

statement_list:
	| statement TERMINATOR statement_list
;

statement:

KEY_ADD NUMBER KEY_TO IDENTIFIER  
	{
		int temp;
		int flag;
		
		flag = search($4);
		
		if(flag == -1) {
			char *t = "Identifier not defined - ";
			yyerror2(3,t, $4);
		} else {
			temp = atoi(tab[flag].value);
			temp = temp + $2;
			
			char val[15];
			val = sprintf(val, "%d", temp);
			
			insertVal(val, flag);
		}
	}
	| KEY_ADD IDENTIFIER KEY_TO IDENTIFIER 
	{
		int temp;
		int temp2;
		int flag;
		int flag2;
		
		flag = search($2);
		flag2 = search($4);
		
		if(flag == -1) {
		
			char *t = "Identifier not defined - ";
			yyerror2(3,t, $2);
			
		} else if(flag2 == -1) {
		
			char *t = "Identifier not defined - ";
			yyerror2(3, t, $4);
			
		} else {
		
			temp = atoi(tab[flag].value);
			temp2 = atoi(tab[flag2].value);
			
			temp = temp + temp2;
			
			char val[15];
			sprintf(val, "%d", temp);
			
			insertVal(val, flag2);
		}
	}
	| KEY_MOVE NUMBER KEY_TO IDENTIFIER 
	{
		int flag;
		
		flag = search($4);
		
		if(flag == -1) {
			char *t = "Identifier not defined - ";
			yyerror2(3,t, $4);
		} else {
			
			char val[15];
			val = sprintf(val, "%d", $2);
			
			insertVal(val, flag);
		}
	}
	| KEY_MOVE IDENTIFIER KEY_TO IDENTIFIER 
	{
		int temp;
		int temp2;
		int flag;
		int flag2;
		
		flag = search($2);
		flag2 = search($4);
		
		if(flag == -1) {
		
			char *t = "Identifier not defined - ";
			yyerror2(3,t, $2);
			
		} else if(flag2 == -1) {
		
			char *t = "Identifier not defined - ";
			yyerror2(3, t, $4);
			
		} else {
		
			insertVal(tab[flag].value, flag2);
			
		}
	}
	| input_statement {}
	| output_statement {}
;

input_statement:
	KEY_INPUT input_list {
		// Loop over the list of variables to read input into
		for(int i = 0; i < $2.size; i++) {
			char input[20];
			scanf("%s", input);
			insertVar($2.vars[i], strlen(input), input);
		}
	}
;

input_list:
	IDENTIFIER {
		$$ = (struct variable_list*)malloc(sizeof(struct variable_list));
		$$->vars[0] = $1;
		$$->size = 1;
	}
	| input_list ';' IDENTIFIER {
		$$ = $1;
		$$->vars[$1->size] = $3;
		$$->size++;
	}
;

output_statement:
	KEY_PRINT output_list {
			// Loop over the list of items to print
			for(int i = 0; i < $2.size; i++) {
			if($2.types[i] == 'S') {
			} else {
			int index = search($2.items[i]);
			if(index == -1) {
			yyerror2(3, "Undefined variable - ", $2.items[i]);
			}
		}
	}
}
;

output_list:
	output_item {
		$$ = (struct output_list*) malloc(sizeof(struct output_list));
		$$->items = (char **) malloc(sizeof(char *));
		$$->types = (int *) malloc(sizeof(int));
		$$->items[0] = $1.output_item;
		$$->types[0] = $1.intValue;
		$$->size0 = 1;
	}
	| output_list CONCATENATOR output_item {
		$$ = $1;
		$$->items = (char **) realloc($$->items, ($1->size0 + 1) * sizeof(char *));
		$$->types = (int *) realloc($$->types, ($1->size0 + 1) * sizeof(int));
		$$->items[$1->size0] = $3.output_item;
		$$->types[$1->size0] = $3.intValue;
		$$->size0 += 1;
	}

%%

int search(char name[]){

	int i;
	int flag = -1;

	for(i = 0; i < ptr; i++){
		if(strcmp(tab[i].name, name) == 0){
			flag = i;
			break;
		}
	}

	return flag;

}


void insertVar(char name[], int size, char value[]) {
	
	strcpy(tab[ptr].name, name);
	strcpy(tab[ptr].value, value);
	tab[ptr].size = size;
	
	ptr++;
}

void insertVal(char value[], int posi){
	
	if(strlen(value) <= tab[posi].size)) {
	
		strcpy(tab[posi].value, value);
		
	} else {
		char *t = "Value too large for variable - ";
		yyerror2(3, t, tab[posi].name);
	}

}

int yyerror(char *s)
{
	printf("Syntax Error on line %d\n%s\n",linenum, s);
	return 0;
}

void yyerror2(int type, char *s, char b[])
{
	
	switch(type){
		case 1:
			printf("Syntax Error on line - %d\n%s\n",linenum, s);
			break;
		case 2:
			printf("Lexical Error on line - %d: %s\n",linenum, s);
			break;
		case 3:
			printf("Line - %d: %s%s\n",linenum, s, b);
			break;
	}

	exit(0);
}

int main()
{
    yyparse();
    return 0;
}
