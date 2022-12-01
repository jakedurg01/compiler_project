#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "symboltable.h"

int current_scope = 0;


unsigned int hash(char* name){
    unsigned int hash_val = 0;
    int i = 1;
    for(;*name!='\0';name++){
        hash_val += *name * i;
        i++;
    } 
        
    hash_val += name[0] % 11 + (name[0] << 3) - name[0];
    hash_val = hash_val % TABLE_SIZE;
    return hash_val;
}

void put(char* name, int line_num){
    //Hash determines index to look
    unsigned int hashed_index = hash(name);
    //Check for existance of symbol -- grab row at index
    Variable_Node* entry = hash_table[hashed_index];
    //Compare to all entries in this chain
    while((entry != NULL) && (strcmp(name, entry->var_name) != 0)){
        entry = entry->next;
    }
    //Found symbol in table
    if(entry != NULL){
        //First note the line number
        Reference_Node *refs = entry->references;
        while( refs != NULL && refs->next != NULL){
            refs = refs->next;
        }
         Reference_Node* new_node = malloc(sizeof(Reference_Node));
        new_node->line = line_num;
        new_node->next = NULL;
        refs->next = new_node;
        //Update scope 
        entry->scope = current_scope;
    //Else create a new var
    }else{
        //Malloc size of new variable
        Variable_Node* new_entry = malloc(sizeof(Variable_Node));
        //Copy in name
        strcpy(new_entry->var_name, name);
        printf("VAR NAME INSIDE PUT :%s\n", new_entry->var_name);
        //Update Scope
        new_entry->scope = current_scope;
        printf("after new scope");
        //Update dec line
        new_entry->declaration_line = line_num;
        //Add a reference node
        Reference_Node* new_node = malloc(sizeof(Reference_Node));
        new_node->line = line_num;
        new_node->next = NULL;
        new_entry->references = new_node;

        //Place into table
        hash_table[hashed_index] = new_entry;

    }
}

Variable_Node* search(char* name){
    unsigned int table_index = hash(name);
    Variable_Node* current = hash_table[table_index];
    //Similar to put, we search the chain for a match
    while((current != NULL) && (strcmp(name, current->var_name) != 0)){
        current = current->next;
    }
    return current;
}

Variable_Node* search_with_scope(char* name, int scope){
    unsigned int table_index = hash(name);
    Variable_Node* current = hash_table[table_index];
    //Similar to put, we search the chain for a match
    while((current != NULL) && (strcmp(name, current->var_name) != 0) && (current_scope != current->scope)){
        current = current->next;
    }
    return current;
}

void hide_scope(){
    if(current_scope>0){
        current_scope--;
    }
}
void increase_scope(){
    printf("increasing scope\n");
    current_scope++;
}

void var_to_file(FILE *output, Variable_Node* node){
    fprintf(output, "|%-14s|%9ld| ", node->var_name, node->value);
    Reference_Node* refs = node->references;
    while(refs != NULL){
        fprintf(output, "%d ", refs->line);
        refs = refs->next;
    }
    fprintf(output, "\n");
}

void symtab_dump(FILE *output){
    fprintf(output, "|      NAME      |  VALUE  | Line Nums\n");
    fprintf(output, "----------------------------------------------------\n");
    int i = 0;
    for(i;i<TABLE_SIZE; i++){
        if(hash_table[i] != NULL){
            Variable_Node* current = hash_table[i];
            while(current != NULL){
                var_to_file(output, current);
                current = current->next;
            }
        }
        

    }
}


void build_hash_table(){
    //Build large enough to have TABLE_SIZE amount of pointers to var nodes
    hash_table = malloc(TABLE_SIZE*sizeof(Variable_Node*));
    int index;
    for(index = 0; index < TABLE_SIZE; index++){
        hash_table[index] = NULL;
    }
}
