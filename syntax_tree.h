#include "symboltable.h"

typedef enum AST_Node_Type {
	ROOT_NODE,
    ASSIGN_NODE, 
	IF_NODE,     // if statement
    ELSE_NODE,
	WHILE_NODE,  // while statement
	CONTROL_NODE, // break/continue
	ARITHM_NODE, // arithmetic expression
	CONDITION_NODE,  // condition
    NUM_NODE 

}AST_Node_Type;

typedef enum Arithmetic_Op{
    ADDITION, SUBTRACTION, MULTIPLICATION, DIVISION
}Arithmetic_Op;

typedef enum Conditional_Op{
    GREATER_THAN, LESS_THAN, EQUAL_TO
}Conditional_Op;

typedef union Node_Val{
    long num_val; //variable values
    char c_val; //For single chars (mostly operators)
    char* str_val; //Keywords
}Node_Val;

typedef struct AST_Node {
    enum AST_Node_Type type;
    struct AST_Node *left;
    struct AST_Node *right;
}AST_Node;

typedef struct AST_Node_Assign{
    enum AST_Node_Type type;
    Variable_Node* entry;
    struct AST_Node *assign_val;
}AST_Node_Assign;

typedef struct AST_Node_If{
    enum AST_Node_Type type;
    struct AST_Node *condition;
    struct AST_Node *if_branch;
    struct AST_Node *else_branch;
}AST_Node_If;

typedef struct AST_Node_While{
    enum AST_Node_Type type;
    struct AST_Node *condition;
    struct AST_Node *while_statements;
}AST_Node_While;

typedef struct AST_Node_Control{
    enum AST_Node_Type type;
    int statement_type;
}AST_Node_Control;

typedef struct AST_Node_Arithmetic{
    enum AST_Node_Type type;
    struct AST_Node *left;
    struct AST_Node *right;
    enum Arithmetic_Op op;
}AST_Node_Arithmetic;

typedef struct AST_Node_Condition{
    enum AST_Node_Type type;
    struct AST_Node *left;
    struct AST_Node *right; 
    enum Conditional_Op op;   
}AST_Node_Condition;

typedef struct AST_Node_Num{
    enum AST_Node_Type type;
    int value_type;
    Node_Val val;
}AST_Node_Num;

AST_Node *new_ast_node(AST_Node_Type type, AST_Node *left, AST_Node* right);
AST_Node *new_ast_assign(Variable_Node* entry, AST_Node *val);
AST_Node *new_ast_if_node(AST_Node *condition, AST_Node *if_branch, AST_Node *else_branch);
AST_Node *new_ast_while(AST_Node *condition, AST_Node *while_statements);
AST_Node *new_ast_control(int statement_type);
AST_Node *new_ast_arithmetic(Arithmetic_Op operand, AST_Node* left_val, AST_Node* right_val);
AST_Node *new_ast_condition(Conditional_Op operand, AST_Node* left_val, AST_Node* right_val);
AST_Node *new_ast_num(int value_type, Node_Val val);
