%{
#include "symboltable.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

void yyerror(const char* msg) {
      fprintf(stderr, "%s\n", msg);
   }
int yylex();
extern FILE* yyin;
extern FILE* yyout;
extern int line_num;
//Nodes for locating the line of usage
// typedef struct Reference_Node{
//     int line;
//     struct Reference_Node* next;
// }Reference_Node;



// //Essentially Symbol Table Nodes
// typedef struct Variable_Node{
//     char var_name[VAR_NAME_MAX_LEN]; //Max var name length 20 chars
//     long value; //Vars only hold integer values
//     int declaration_line; //Line on which var is declared/initalized
//     Reference_Node* references; //Lines that reference this varialbe

// }Variable_Node;


// //Max of 100 declared variables
// Variable_Node variables[MAX_VARS];

// //Essentially insert index
// int total_vars = 0;



// int insert_reference(int var_index, int line_num){
//     Reference_Node new_node = {.line = line_num, .next = NULL};
//     Reference_Node* cursor = variables[var_index].references;
//     //If this is not the first reference in the list
//     if(cursor != NULL){
//         //Find final node
//         while(cursor->next != NULL){
//             cursor = cursor->next;
//         }
//         cursor->next = &new_node;
//         return 0;
//     //Otherwise is first reference
//     }else{
//         variables[var_index].references = &new_node;
//         return 0;
//     }
//     return 0;
// }

// //Searches variables array for a name, returns its index or -1 if it doesn't exist
// int find_var(char name[VAR_NAME_MAX_LEN]){
//     int i = 0;
//     //For each var in variables array...
//     for(i=0;i<total_vars;i++){
//         //Compare to name
//         int comparison = strcmp(variables[i].var_name, name);
//         if(comparison == 0){
//             return i;
//         }
//     }
//     return -1;
// }


void yyerror();
%}

%union{
    long val;
    char *strVal;
    // struct Variable_Node *symbol_table_entry;
}

%token NUM IF WHILE VAR EQL OPEN_PAREN CLOSE_PAREN ADD SUB MULT DIV ASGN GT LT OPEN_BRACKET CLOSE_BRACKET SEMI_COLON NL CONTINUE BREAK

%type<val> NUM arithmetic_exp factor term condition
/* %type<symbol_table_entry> VAR */

%%
lojban: 
    statement NL lojban {printf("var assignment found\n");}
    | /*Lambda*/
statement:
    assignment_statement {}
    | if_statement {}
    | while_statement {}
    | CONTINUE {}
    | BREAK {}
if_statement:
    IF OPEN_PAREN condition CLOSE_PAREN OPEN_BRACKET lojban CLOSE_BRACKET {}
while_statement:
    WHILE OPEN_PAREN condition CLOSE_PAREN OPEN_BRACKET lojban CLOSE_BRACKET {}
assignment_statement:
    VAR ASGN arithmetic_exp SEMI_COLON
arithmetic_exp:
    arithmetic_exp ADD factor {}
    | arithmetic_exp SUB factor {}
    | factor {}
factor:
    factor MULT term {}
    | factor DIV term {}
    | term {}
term:
    OPEN_PAREN arithmetic_exp CLOSE_PAREN {}
    | NUM {}
    | VAR {}
condition:
    term EQL term {}
    | term GT term {}
    | term LT term {}
    | NUM {}
    | VAR {}

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

/* void yyerror() {
  printf("Parser error at line %d\n", line_number);
  exit(-1);
} */
