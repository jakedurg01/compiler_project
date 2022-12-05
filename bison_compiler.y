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

%type<val> NUM
%type<symbol_table_entry> VAR
%type<ast_node> lojban statements statement condition term arithmetic_exp factor assignment_statement if_statement while_statement
%start lojban

%%
lojban: 
    statements END {
        //Imported from syntax_tree.h
        program_root = new_ast_node(ROOT_NODE, $1, NULL);
        return 0;
    }
statements:
    statement statements {
        $$ = new_ast_node(ROOT_NODE, $1, $2);
    }
    | statement {}
statement:
    assignment_statement {$$=$1;} //Pass reference up the chain
    | if_statement {$$=$1;}
    | while_statement {$$=$1;}
if_statement:
    IF OPEN_PAREN condition CLOSE_PAREN OPEN_BRACKET statements CLOSE_BRACKET {
        $$ = (AST_Node*) new_ast_if($3, $6);
    }
while_statement:
    WHILE OPEN_PAREN condition CLOSE_PAREN OPEN_BRACKET statements CLOSE_BRACKET {
        $$ = (AST_Node*) new_ast_while($3, $6);
    }
assignment_statement:
    VAR ASGN arithmetic_exp SEMI_COLON {
        $$ = (AST_Node*) new_ast_assign($1, $3);
    }
arithmetic_exp:
    arithmetic_exp ADD factor {
        $$ = (AST_Node*) new_ast_arithmetic(ADDITION, $1, $3);
    }
    | arithmetic_exp SUB factor {
        $$ = (AST_Node*) new_ast_arithmetic(SUBTRACTION, $1, $3);
    }
    | factor {$$ = $1;}
factor:
    factor MULT term {
        $$ = (AST_Node*) new_ast_arithmetic(MULTIPLICATION, $1, $3);
    }
    | factor DIV term {
        $$ = (AST_Node*) new_ast_arithmetic(DIVISION, $1, $3);
    }
    | term {$$ = $1;}
term:
    OPEN_PAREN arithmetic_exp CLOSE_PAREN {$$ = $2;} //Just pass along reference to AST_Node from arith exp
    | NUM {
        AST_Node* val_node = (AST_Node*) new_ast_num(0, $1, NULL);
        AST_Node* rtn_node = (AST_Node*) new_ast_arithmetic(NONE, val_node, NULL);
        $$=rtn_node;
    }
    | VAR {
        AST_Node* val_node = (AST_Node*) new_ast_num(1, 0, $1);
        AST_Node* rtn_node = (AST_Node*) new_ast_arithmetic(NONE, val_node, NULL);
        $$=rtn_node;
    }
condition:
    term EQL term {$$ = (AST_Node*) new_ast_condition(EQUAL_TO,$1, $3);}
    | term GT term {$$ = (AST_Node*) new_ast_condition(GREATER_THAN,$1, $3);}
    | term LT term {$$ = (AST_Node*) new_ast_condition(LESS_THAN ,$1, $3);}

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
    ast_traversal(program_root);
    fclose(yyin);

    yyout= fopen("table_dump.txt", "w");
    symtab_dump(yyout);
    fclose(yyout);
    return 0;
}

