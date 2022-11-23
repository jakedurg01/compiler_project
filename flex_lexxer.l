%{

 /* definitions */  
#include <stdlib.h>
#include "bison_compiler.tab.h"

extern int yylex();    

%}
%option noyywrap
ID $[a-zA-Z][a-zA-Z0-9_]*
DIGIT [0-9]

/* Rules */
%%



[ \t]+                {printf("Valid Space\n");}
{ID}                  {printf("Valid Var: %s\n", yytext); return VAR;}
{DIGIT}*              {printf("Valid Integer: %s\n", yytext); return NUM;}
";"                   {printf("END OF LINE\n"); return EOL;}
"if"                  {printf("Valid If\n"); return IF;}
"repeat"              {printf("Valid repeat\n"); return REPEAT;}
"end"                 {printf("Valid end\n"); return END;}
"+"                   {printf("Valid +\n"); return ADD;}
"-"                   {printf("Valid -\n"); return SUB;}
"*"                   {printf("Valid *\n"); return MUL;}
"/"                   {printf("Valid +\n"); return DIV;}
"="                   {printf("Valid =\n"); return ASSIGN;}
"=="                  {printf("Valid ==\n"); return EQL;}
"stop"                {printf("Stopping..."); return STOP;}



%%

/* [ \t]+                {printf("Valid Space\n");}
{ID}                  {printf("Valid Var: %s\n", yytext); return VAR;}
{DIGIT}*              {printf("Valid Integer: %s\n", yytext); yylval = atoi(yytext); return NUMBER;}
";\n"                 {printf("END OF LINE\n"); return EOL;}
"if"                  {printf("Valid If\n"); return IF;}
"repeat"              {printf("Valid repeat\n"); return REPEAT;}
"end"                 {printf("Valid end\n"); return END;}
"+"                   {printf("Valid +\n"); return ADD;}
"-"                   {printf("Valid -\n"); return SUB;}
"*"                   {printf("Valid *\n"); return MUL;}
"/"                   {printf("Valid +\n"); return DIV;}
"="                   {printf("Valid =\n"); return ASSIGN;}
"=="                  {printf("Valid ==\n"); return EQL;}
"stop"                {printf("Stopping..."); return STOP;} */

/* [ \t]+                {printf("Valid Space\n");}
{ID}                  {printf("Valid Var: %s\n", yytext);}
{DIGIT}*              {printf("Valid Integer: %s\n", yytext); yylval = atoi(yytext);}
";\n"                 {printf("END OF LINE\n"); }
"if"                  {printf("Valid If\n"); }
"repeat"              {printf("Valid repeat\n"); }
"end"                 {printf("Valid end\n"); }
"+"                   {printf("Valid +\n"); }
"-"                   {printf("Valid -\n");}
"*"                   {printf("Valid *\n");}
"/"                   {printf("Valid +\n");}
"="                   {printf("Valid =\n");}
"=="                  {printf("Valid ==\n");}
"stop"                {printf("Stopping...");} */
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