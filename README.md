# compiler_project
Using Flex and Bison to create a Compiler for a basic programming language 

Commands to run:
bison -d bison_compiler.y
flex flex_lexxer.l
gcc bison_compiler.tab.c lex.yy.c symboltable.c syntax_tree.c -ll -o bin/compiler
./bin/compiler

Input is read from test_lojban_file.txt
