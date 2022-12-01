%option noyywrap
%{

 /* definitions */  
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "symboltable.h"
#include "bison_compiler.tab.h"

extern FILE *yyin;
extern FILE *yyout;
int line_num = 1;
%}

/* Variable identifiers must be between 1 and 20 chars*/
VARIABLE $[a-zA-Z0-9_]{1,20}
NUM [0-9]


/* Rules */
%%



[ \t]+                          {}
{VARIABLE}                      {
                                    printf("Valid Var: %s\n", yytext);
                                    printf("Line Num:%d\n", line_num); 
                                    char* temp = yytext;
                                    printf("TESTING PRINT\n");
                                    printf("TESTING TEMP PRINT %s\n", temp);
                                    search(yytext);
                                    printf("AFTER SEARCH\n");
                                    put(temp, line_num);
                                    FILE* outFile = fopen("table_dump.txt", "w");
                                    symtab_dump(outFile);
                                    fclose(outFile);
                                    // yylval.symbol_table_entry = search(yytext);
                                    return VAR;
                                }
{NUM}+                          {printf("Valid Integer: %s\n", yytext); yylval.val = atol(yytext); return NUM;}
"+"                             {return ADD;}
"-"                             {return SUB;}
"*"                             {return MULT;}
"/"                             {return DIV;}
"=="                            {return EQL;}
"="                             {return ASGN;}
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
"\n"                            {line_num+=1; return NL;}


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