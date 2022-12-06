# compiler_project
Using Flex and Bison to create a Compiler for a basic programming language.

Commands to run:
bison -d bison_compiler.y
flex flex_lexxer.l
gcc bison_compiler.tab.c lex.yy.c symboltable.c syntax_tree.c -ll -o bin/compiler
./bin/compiler

Input is read from test_lojban_file.txt

Variables begin with a $ and have names of up to 20 characters in [_0-9a-zA-z]+. Variables can only take integer values (stored as longs).

Operators:

Conventional --> lojban
+ --> "su'i"
- --> "vu'u"
* --> "pi'i"
/ --> "fi'u"
== (equality operator) --> "dunli"
= (assignment operator) --> "du"
\> --> "zmadu"
< --> "mleca"
if --> "ijanai"
while --> "ze'aba"
end --> "de'a"

Whenever ./bin/compiler is run, it prints the traversal of the ast syntax tree to the console, and produces a "table_dump.txt" that displays the variable names, values, and line numbers on which they appear. 


Some inspiration taken from: https://steemit.com/utopian-io/@drifter1/writing-a-simple-compiler-on-my-own-action-rules-for-function-calls-c-flex-bison
