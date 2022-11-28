%{
#include <stdlib.h>
#include <stdio.h>
#include <math.h>
extern int yylex();
extern int yyparse();
extern FILE* yyin;

void yyerror(const char *s);
%}
%union{
    int ival;
    char *sval;
}

%token <ival> NUM
%token <sval> SPACE
%token <sval> IF
%token <sval> ELSE
%token <sval> THEN
%token <sval> END
%token <sval> STOP
%token <sval> REPEAT
%token <sval> VAR
%token <sval> EQL

%%
lojban:
    assignment END | assignment lojban{printf("var assignment found\n");}
assignment:
    VAR '=' arithmetic_exp ';'
arithmetic_exp:
    arithmetic_exp '+' factor | arithmetic_exp '-' factor | factor
factor:
    factor '*' term | factor '/' term | term
term:
    '(' term ')' | NUM | VAR

%%
//bison -d bison_compiler.y
//flex flex_lexxer.l
//gcc bison_compiler.tab.c lex.yy.c -ll -o bin/compiler

int main(int, char**) {
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
  
}

void yyerror(const char *s) {
  printf("Parser error: %s\n", s);
  exit(-1);
}
