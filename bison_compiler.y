%{
#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <string.h>
#define MAX_VARS 100
#define VAR_NAME_MAX_LEN 21
extern int yylex();
extern int yyparse();
extern FILE* yyin;
extern FILE* yyout;


struct variable_format{
    char var_name[VAR_NAME_MAX_LEN]; //Max var name length 20 chars
    long numVal; //Vars only hold integer values
};

//Max of 100 declared variables
struct variable_format variables[MAX_VARS];

//Essentially insert index
int total_vars = 0;

//Searches variables array for a name, returns its index or -1 if it doesn't exist
int find_var(char name[VAR_NAME_MAX_LEN]){
    int i = 0;
    //For each var in variables array...
    for(i=0;i<total_vars;i++){
        //Compare to name
        int comparison = strcmp(variables[i].var_name, name);
        if(comparison == 0){
            return i;
        }
    }
    return -1;
}


void yyerror(const char *s);
%}
%union{
    long val;
    char *strVal;
}

%token NUM SPACE IF ELSE THEN END STOP FOR VAR EQL OPEN_PAREN CLOSE_PAREN

%type<val> NUM arithmetic_exp factor term
%type<strVal> VAR OPEN_PAREN CLOSE_PAREN

%%
lojban:
    assignment END | assignment lojban{printf("var assignment found\n");}
assignment:
    VAR '=' arithmetic_exp ';' {
        printf("Assigning var %s value: %ld\n", $1, $3);
        int index = find_var($1);
        //Var does not exist already
        if(index == -1){
            //Check for space
            if(total_vars >= MAX_VARS-1){
                printf("Max number of variables reached\n");
            }else{
                strcpy(variables[total_vars].var_name, $1);
                variables[total_vars].numVal = $3;
                total_vars++;
            }
        }else{
            variables[index].numVal = $3; 
        }
        printf("Var 0 name: %s\nValue: %ld\n", variables[0].var_name, variables[0].numVal);
        printf("Var 1 name: %s\nValue: %ld\n", variables[1].var_name, variables[1].numVal);
    }
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
    | VAR {
        int index = find_var($1);
        if(index>-1){
            $$ = variables[index].numVal;
        }else{
            printf("Error -- variable %s not found\n", $1);
        }
    }

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
