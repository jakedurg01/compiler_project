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
                                    put(yytext, line_num);
                                    yylval.symbol_table_entry = search(yytext);
                                    return VAR;
                                }
{NUM}+                          {yylval.val = atol(yytext); return NUM;}
"su'i"                             {return ADD;}
"vu'u"                             {return SUB;}
"pi'i"                             {return MULT;}
"fi'u"                             {return DIV;}
"dunli"                            {return EQL;}
"du"                               {return ASGN;}
"zmadu"                            {return GT;}
"mleca"                            {return LT;}
"{"                             {return OPEN_BRACKET;}
"}"                             {return CLOSE_BRACKET;}
"ijanai"                            {return IF;}
"ze'aba"                         {return WHILE;/*Translates to mediam-time-interval in present tense, not necessarily "while this do this" but more like "for a while do this"*/}
";"                             {return SEMI_COLON;}
"("                             {return OPEN_PAREN;}
")"                             {return CLOSE_PAREN;}
"de'a"                           {return END;/*Stop or pause in lojban*/} 
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