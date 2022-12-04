%option noyywrap
%{

 /* definitions */  
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "symboltable.h"
#include "bison_compiler.tab.h"
#include "syntax_tree.h"

extern FILE *yyin;
extern FILE *yyout;
int line_num = 1;
%}

/* Variable identifiers must be between 1 and 20 chars*/
VARIABLE $[a-zA-Z0-9_]{1,20}
NUM [0-9]


/* Rules */
%%



{VARIABLE}                      {
                                    printf("Valid Var: %s\n", yytext);
                                    put(yytext, line_num);
                                    yylval.symbol_table_entry = search(yytext);
                                    return VAR;
                                }
{NUM}+                          {printf("Valid Integer: %s\n", yytext); yylval.val = atol(yytext); return NUM;}
"+"                             {return ADD;}
"-"                             {return SUB;}
"*"                             {return MULT;}
"/"                             {return DIV;}
"=="                            {return EQL;}
"="                             {printf("Assignment Equals\n");return ASGN;}
">"                             {return GT;}
"<"                             {return LT;}
"{"                             {return OPEN_BRACKET;}
"}"                             {return CLOSE_BRACKET;}
"continue"                      {return CONTINUE;}
"break"                         {return BREAK;}
"if"                            {return IF;}
"while"                         {return WHILE;}
";"                             {return SEMI_COLON;}
"("                             {return OPEN_PAREN;}
")"                             {return CLOSE_PAREN;}
"end"                           {return END;}
"\n"                            {line_num+=1;}
[ \t]+
.                               {printf("skipping character: \"%s\"", yytext);}


%%

/* int main() {



    //flex flex_lexxer.l
    //gcc lex.yy.c -o bin/lex_compiled  
    //printf("Enter string: ");
    FILE* infile = fopen("test_lojban_file.txt", "r");
    if(!infile){
        printf("Error opening file");
        return -1;
    }else{
        yyin = infile;
    }
    while(yylex());


    return 0;
} */