#include "syntax_tree.h"
#include "symboltable.h"
#include <stdlib.h>

AST_Node *new_ast_node(AST_Node_Type type, AST_Node *left, AST_Node* right){
    AST_Node *new_node = (AST_Node*) malloc(sizeof(AST_Node));
    new_node->type = type;
    new_node->left = left;
    new_node->right = right;
    return new_node;
}

AST_Node *new_ast_assign(Variable_Node* entry, AST_Node *val){
    AST_Node_Assign *new_node = (AST_Node_Assign*)malloc(sizeof(AST_Node_Assign));
    new_node->type = ASSIGN_NODE;
    new_node->entry = entry;
    new_node->assign_val = val;
    return (struct AST_Node *) new_node;
}

AST_Node *new_ast_if(AST_Node *condition, AST_Node *if_branch){
    AST_Node_If *new_node = (AST_Node_If*) malloc(sizeof(AST_Node_If));
    new_node->type = IF_NODE;
    new_node->condition = condition;
    new_node->if_branch = if_branch;
    return (struct AST_Node *) new_node;    
}

AST_Node *new_ast_while(AST_Node *condition, AST_Node *while_statements){
    AST_Node_While *new_node = (AST_Node_While*) malloc(sizeof(AST_Node_While));
    new_node->type = WHILE_NODE;
    new_node->condition = condition;
    new_node->while_statements = while_statements;
    return (struct AST_Node *) new_node;
}


AST_Node *new_ast_arithmetic(Arithmetic_Op operand, AST_Node* left_val, AST_Node* right_val){
    AST_Node_Arithmetic *new_node = (AST_Node_Arithmetic*) malloc(sizeof(AST_Node_Arithmetic));
    new_node->type = ARITHM_NODE;
    new_node->op = operand;
    new_node->left = left_val;
    new_node->right = right_val;
    return (struct AST_Node*) new_node;
}

AST_Node *new_ast_condition(Conditional_Op operand, AST_Node* left_val, AST_Node* right_val){
    AST_Node_Condition *new_node = (AST_Node_Condition*) malloc(sizeof(AST_Node_Condition));
    new_node->type = CONDITION_NODE;
    new_node->op = operand;
    new_node->left = left_val;
    new_node->right = right_val;
    new_node->val = NULL;
    return (struct AST_Node*) new_node;
}

AST_Node *new_ast_num(int var_flag, long val, Variable_Node* entry){
    AST_Node_Num *new_node = (AST_Node_Num*) malloc(sizeof(AST_Node_Num));
    new_node->type = NUM_NODE;
    new_node->var_flag = var_flag;
    new_node->val = val;
    new_node->entry = entry;
    return (struct AST_Node*) new_node;
}


void ast_print_node(AST_Node *node){
    AST_Node_Assign *temp_assign;
    AST_Node_Arithmetic *temp_arithmetic;
    AST_Node_Condition *temp_condition;
    AST_Node_Num *temp_num;


    switch(node->type){
        case ROOT_NODE:
            printf("Root node\n");
            break;
        case ASSIGN_NODE:
            temp_assign = (struct AST_Node_Assign*) node;
            printf("Assigning variable %s \n", temp_assign->entry->var_name);
            break;
        case NUM_NODE:
            temp_num = (struct AST_Node_Num*) node;
            printf("Num Node with value %ld\n", temp_num->val);
            break;
        case IF_NODE:
            printf("If node\n");
            break;
        case WHILE_NODE:
            printf("While Node\n");
            break;
        case ARITHM_NODE:
            temp_arithmetic = (struct AST_Node_Arithmetic*) node;
            printf("Arithmetic node for operator %d\n", temp_arithmetic->op);
            break;
        case CONDITION_NODE:
            temp_condition = (struct AST_Node_Condition*) node;
            printf("Condition node with operator %d\n", temp_condition->op);
            break;
        default:
            printf("Error in determining type\n");
            exit(1);

    }
}

void ast_traversal(AST_Node *node){

    if(node == NULL){
        return;
    }
    enum AST_Node_Type type = node->type;
    if(type == ROOT_NODE){
        ast_traversal(node->left);
        ast_traversal(node->right);
    }else if (type == CONDITION_NODE){
        AST_Node_Condition *temp = (struct AST_Node_Condition*) node;
        ast_traversal(node->left);
        ast_traversal(node->right);

        long left_val;
        long right_val;

        AST_Node_Arithmetic *left_arith = (struct AST_Node_Arithmetic*) temp->left;
        AST_Node_Arithmetic *right_arith = (struct AST_Node_Arithmetic*) temp->right;

        left_val = left_arith->val;
        right_val = right_arith->val;

        if(temp->op == EQUAL_TO){
            if(left_val == right_val){
                temp->val = 1;
            }else{
                temp->val = 0;
            }
        }else if(temp->op == GREATER_THAN){
            if(left_val > right_val){
                temp->val = 1;
            }else{
                temp->val = 0;
            }
        }else if(temp->op == LESS_THAN){
            if(left_val < right_val){
                temp->val = 1;
            }else{
                temp->val = 0;
            }
        }else{
            printf("Invalid conditional operator\n");
        }

    }
    else if(type==ARITHM_NODE){
        AST_Node_Arithmetic *temp = (struct AST_Node_Arithmetic*) node;
        ast_traversal(node->left);
        ast_traversal(node->right);
        if(temp->op == ADDITION){
            //If no right node, we are at bottom of tree
            if(temp->right == NULL){
                temp->val = ((struct AST_Node_Arithmetic*) temp->left)->val;
            }else{
                temp->val = ((struct AST_Node_Arithmetic*) temp->left)->val + ((struct AST_Node_Arithmetic*) temp->right)->val;
            }
        }else if(temp->op == SUBTRACTION){
             //If no right node, we are at bottom of tree
            if(temp->right == NULL){
                temp->val = ((struct AST_Node_Arithmetic*) temp->left)->val;
            }else{
                temp->val = ((struct AST_Node_Arithmetic*) temp->left)->val - ((struct AST_Node_Arithmetic*) temp->right)->val;
            }
        }else if (temp->op == MULTIPLICATION){
            if(temp->right == NULL){
                temp->val = ((struct AST_Node_Arithmetic*) temp->left)->val;
            }else{
                temp->val = ((struct AST_Node_Arithmetic*) temp->left)->val * ((struct AST_Node_Arithmetic*) temp->right)->val;
            }
        }else if(temp->op == DIVISION){
            if(temp->right == NULL){
                temp->val = ((struct AST_Node_Arithmetic*) temp->left)->val;
            }else{
                temp->val = ((struct AST_Node_Arithmetic*) temp->left)->val / ((struct AST_Node_Arithmetic*) temp->right)->val;
            }
        }else if(temp->op == NONE){
            //We know left node will have reference to a Node_Num type
            AST_Node_Num* node_num = (struct AST_Node_Num*) temp->left;
            if(node_num->var_flag == 1){
                //Get val from variable
                temp->val = node_num->entry->value;
            }else{
                //Literal stored in num node
                temp->val = node_num->val;
            }
        }else{
            printf("ERROR temp op not invalid/not found\n");
        }
    }
    else if(type == IF_NODE){
        AST_Node_If *temp = (struct AST_Node_If*) node;
        ast_traversal(temp->condition);
        if(temp->condition->type == CONDITION_NODE){
            AST_Node_Condition *cond = (AST_Node_Condition*) temp->condition;
            //Only if condition do we traverse interior, otherwise skip
            if(cond->val != 0){
                ast_traversal(temp->if_branch);
            }
        }else{
            printf("Error, invalid condition node\n");
        }
    }
    else if(type == ASSIGN_NODE){
        AST_Node_Assign *temp = (struct AST_Node_Assign*) node;
        ast_traversal(temp->assign_val);
        if(temp->assign_val->type == ARITHM_NODE){
            temp->entry->value = ((struct AST_Node_Arithmetic*) temp->assign_val)->val;
        }else if(temp->assign_val->type == NUM_NODE){
            temp->entry->value = ((struct AST_Node_Num*) temp->assign_val)->val;
        }else{
            printf("Error, neither Arithmetic nor NUM\n");
        }
    }
    else if(type == WHILE_NODE){
        AST_Node_While *temp = (struct AST_Node_While*) node;
        
        while(1){
            ast_traversal(temp->condition);
            if(((AST_Node_Condition*)temp->condition)->val == 1){
                ast_traversal(temp->while_statements);
            }else{
                break;
            }
        }
        
    }

    ast_print_node(node);
}

// int main(){
//     long val1, val2;
//     val1 = 15;
//     val2 = 20;
//     AST_Node *const_node1 = new_ast_num( val1);
//     AST_Node *const_node2 = new_ast_num( val2);
//     AST_Node *condition_node = new_ast_condition(LESS_THAN, const_node1, const_node2);
//     AST_Node *root_node = new_ast_node(ROOT_NODE, NULL, NULL);
//     AST_Node *if_node = new_ast_if(condition_node, root_node, 0);
//     ast_traversal(if_node);
//     return 0;
// }