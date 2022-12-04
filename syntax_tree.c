#include "syntax_tree.h"
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

AST_Node *new_ast_if(AST_Node *condition, AST_Node *if_branch, AST_Node *else_branch){
    AST_Node_If *new_node = (AST_Node_If*) malloc(sizeof(AST_Node_If));
    new_node->type = IF_NODE;
    new_node->condition = condition;
    new_node->if_branch = if_branch;
    new_node->else_branch = else_branch;
    return (struct AST_Node *) new_node;    
}

AST_Node *new_ast_while(AST_Node *condition, AST_Node *while_statements){
    AST_Node_While *new_node = (AST_Node_While*) malloc(sizeof(AST_Node_While));
    new_node->type = WHILE_NODE;
    new_node->condition = condition;
    new_node->while_statements = while_statements;
    return (struct AST_Node *) new_node;
}

AST_Node *new_ast_control(int statement_type){
    AST_Node_Control *new_node = (AST_Node_Control*) malloc(sizeof(AST_Node_Control));
    new_node->type = CONTROL_NODE;
    new_node->statement_type = statement_type;
    return (struct AST_Node*) new_node;
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
    return (struct AST_Node*) new_node;
}

AST_Node *new_ast_num(int value_type, Node_Val val){
    AST_Node_Num *new_node = (AST_Node_Num*) malloc(sizeof(AST_Node_Num));
    new_node->type = NUM_NODE;
    new_node->value_type = value_type;
    new_node->val = val;
    return (struct AST_Node*) new_node;
}


void ast_print_node(AST_Node *node){
    AST_Node_Assign *temp_assign;
    AST_Node_Control *temp_control;
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
            printf("Num Node with type %d and value %ld\n", temp_num->value_type, temp_num->val.num_val);
            break;
        case IF_NODE:
            printf("If node\n");
            break;
        case WHILE_NODE:
            printf("While Node\n");
            break;
        case CONTROL_NODE:
            temp_control = (struct AST_Node_Control*) node;
            printf("Control Node of type: %d\n", temp_control->statement_type);
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
    int i;

    if(node == NULL){
        return;
    }
    enum AST_Node_Type type = node->type;
    if(type == ROOT_NODE || type == ARITHM_NODE || type == CONDITION_NODE){
        ast_traversal(node->left);
        ast_traversal(node->right);
    }
    else if(type == IF_NODE){
        AST_Node_If *temp = (struct AST_Node_If*) node;
        ast_traversal(temp->condition);
        ast_traversal(temp->if_branch);
        ast_traversal(temp->else_branch);
    }
    else if(type == ASSIGN_NODE){
        AST_Node_Assign *temp = (struct AST_Node_Assign*) node;
        ast_traversal(temp->assign_val);
    }
    else if(type == WHILE_NODE){
        AST_Node_While *temp = (struct AST_Node_While*) node;
        ast_traversal(temp->condition);
        ast_traversal(temp->while_statements);
    }

    ast_print_node(node);
}

// int main(){
//     Node_Val val1, val2;
//     val1.num_val = 15;
//     val2.num_val = 20;
//     AST_Node *const_node1 = new_ast_num(0, val1);
//     AST_Node *const_node2 = new_ast_num(0, val2);
//     AST_Node *condition_node = new_ast_condition(LT, const_node1, const_node2);
//     AST_Node *root_node = new_ast_node(ROOT_NODE, NULL, NULL);
//     AST_Node *if_node = new_ast_if(condition_node, root_node, 0);
//     ast_traversal(if_node);
//     return 0;
// }