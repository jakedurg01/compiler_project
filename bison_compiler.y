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
    long val;
    char *strVal;
}

%token NUM SPACE IF ELSE THEN END STOP REPEAT VAR EQL OPEN_PAREN CLOSE_PAREN

%type<val> NUM arithmetic_exp factor term
%type<strVal> VAR OPEN_PAREN CLOSE_PAREN

%%
lojban:
    assignment END | assignment lojban{printf("var assignment found\n");}
assignment:
    VAR '=' arithmetic_exp ';' {printf("Assigning var %s value: %ld", $1, $3)}
arithmetic_exp:
    arithmetic_exp '+' factor {$$ = $1 + $3;}
    | arithmetic_exp '-' factor {$$ = $1 - $3;}
    | factor {$$ = $1;}
factor:
    factor '*' term {$$ = $1 * $3;}
    | factor '/' term {$$ = $1 / $3;}
    | term {$$ = $1;}
term:
    OPEN_PAREN arithmetic_exp CLOSE_PAREN {$$ = $2; printf("Parenthesis value: %ld\n", $2);}
    | NUM {$$ = $1;}
    | VAR

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
