%{

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "symboltable.h"
#include "syntax_tree.h"

int yylex();
extern FILE* yyin;
extern FILE* yyout;
extern int line_num;
void yyerror(const char* msg) {
      fprintf(stderr, "[ERROR] %s while processing line %d of the input file\n", msg, line_num);
   }


void yyerror();
%}

%union{
    long val;
    char *strVal;
    struct Variable_Node *symbol_table_entry;
    struct AST_Node *ast_node;
}

%token NUM IF WHILE VAR EQL OPEN_PAREN CLOSE_PAREN ADD SUB MULT DIV ASGN GT LT OPEN_BRACKET CLOSE_BRACKET SEMI_COLON NL CONTINUE BREAK END

%type<val> NUM arithmetic_exp factor term condition
%type<symbol_table_entry> VAR
%start lojban

%%
lojban: 
    statements END {printf("Stopping...\n");Node_Val test_val; test_val.num_val=10 ; AST_Node* test = new_ast_num(0, test_val );return 0;}
statements:
    statement statements {}
    | statement {}
statement:
    assignment_statement {}
    | if_statement {}
    | while_statement {}
    | CONTINUE {}
    | BREAK {}
if_statement:
    IF OPEN_PAREN condition CLOSE_PAREN OPEN_BRACKET statements CLOSE_BRACKET {}
while_statement:
    WHILE OPEN_PAREN condition CLOSE_PAREN OPEN_BRACKET statements CLOSE_BRACKET {}
assignment_statement:
    VAR ASGN arithmetic_exp SEMI_COLON {$1->value = $3; printf("Assigning %s value %ld\n", $1->var_name, $3);}
arithmetic_exp:
    arithmetic_exp ADD factor {$$ = $1 + $3;}
    | arithmetic_exp SUB factor {$$ = $1 - $3;}
    | factor {$$ = $1;}
factor:
    factor MULT term {$$ = $1 * $3;}
    | factor DIV term {$$ = $1 / $3;}
    | term {$$ = $1;}
term:
    OPEN_PAREN arithmetic_exp CLOSE_PAREN {$$ = $2;}
    | NUM {}
    | VAR {$$=$1->value;}
condition:
    term EQL term {if ($1 == $3){$$=1;}else{$$=0;}}
    | term GT term {if ($1 > $3){$$=1;}else{$$=0;}}
    | term LT term {if ($1 < $3){$$=1;}else{$$=0;}}
    | term {if ($1 != 0){$$=1;}else{$$=0;}}

%%
//bison -d bison_compiler.y
//flex flex_lexxer.l
//gcc bison_compiler.tab.c lex.yy.c -ll -o bin/compiler

int main(int in, char** args) {
    build_hash_table();
    // Open a file handle to a particular file:
    FILE *myfile = fopen("test_lojban_file.txt", "r");
    // Make sure it is valid:
    if (!myfile) {
    printf("File Error");
    return -1;
    }
    // Set Flex to read from it instead of defaulting to STDIN:
    yyin = myfile;

    // Parse through the input:
    yyparse();
    fclose(yyin);

    yyout= fopen("table_dump.txt", "w");
    symtab_dump(yyout);
    fclose(yyout);
    return 0;
}

