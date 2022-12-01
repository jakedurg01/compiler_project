#ifndef SYMBOLTABLE_H
#define SYMBOLTABLE_H

#include <stdio.h>
#define VAR_NAME_LENGTH 21 //To account for $

#define TABLE_SIZE 131 //prime number

//Types
#define NUM_TYP 0
#define CONTROL_TYPE 1

//Nodes for locating the line of usage
typedef struct Reference_Node{
    int line;
    struct Reference_Node* next;
}Reference_Node;

//Essentially Symbol Table Nodes
typedef struct Variable_Node{
    char var_name[VAR_NAME_LENGTH]; //Max var name length 20 chars
    long value; //Vars only hold integer values
    int declaration_line; //Line on which var is declared/initalized
    int scope; //used to look for greatest, to least.
    Reference_Node* references; //Lines that reference this varialbe
    struct Variable_Node* next; //for seprate chaining hashtable
}Variable_Node;


unsigned int hash(char* name);
void put(char* name, int line_num);
Variable_Node* search(char* name);
Variable_Node* search_with_scope(char* name, int scope);
void hide_scope();
void increase_scope();
void symtab_dump(FILE *output);
void build_hash_table();

static Variable_Node **hash_table;
#endif