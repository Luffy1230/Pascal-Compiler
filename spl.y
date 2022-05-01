%{
    #include <iostream>
    #include <cstdio>
    #include <string>
    #include "ast.h"

    using namespace std;

    // Error Message Output
    void yyerror(const char *s)
    {
        std::printf("Error: %s\n", s);
        std::exit(1);
    }

    int yylex(void);

    // The Root of Program
    Program *root;
%}

%union {
    // Primitive
    int iVal;
    string *sVal;
    double dVal;
    bool bVal;
    char cVal;

    // Class
    Integer *integer;
    Real *real;
    Char *astChar;
    Boolean *boolean;

    Node *node;
    Expression *expression;
    Statement *statement;

    ConstDecl *constDecl;
    TypeDecl *typeDecl;
    VarDecl *varDecl;

    AstType *type;
    EnumType *enumType;
    AstArrayType *astArrayType;
    RecordType *recordType;
    ConstRangeType *constRangeType;
    EnumRangeType *enumRangeType;

    ConstVal *constVal;
    Identifier *identifier;

    FieldDecl *fieldDecl;
    FuncDecl *funcDecl;
    Parameter *parameter;
    Routine *routine;
    Program *program;

    FunctionCall *functionCall;
    SysFunctionCall *sysFunctionCall;
    ProcedureCall *procedureCall;
    SysProcedureCall *sysProcedureCall;

    AssignStat *assignStat;
    BinaryExpr *binaryExpr;
    ArrayRefer *arrayRefer;
    RecordRefer *recordRefer;

    IfStat *ifStat;
    ForStat *forStat;
    WhileStat *whileStat;
    RepeatStat *repeatStat;
    CaseStat *caseStat;
    CaseExpr *caseExpr;
    GotoStat *gotoStat;

    ExpressionList *expressionList;
    StatementList *statementList;
    ConstDeclList *constDeclList;

    VarDeclList *varDeclList;
    TypeDeclList *typeDeclList;
    NameList *nameList;
    FieldList *fieldList;
    ParaList *paraList;
    RoutineList *routineList;
    ArgsList *argsList;
    CaseExprList *caseExprList;
    CompoundStat *compoundStat;
}

%token LP RP LB RB DOT COMMA COLON SEMI
       PLUS MINUS MUL DIV MOD
       EQUAL UNEQUAL NOT AND OR
       GE GT LE LT
       ASSIGN ARRAY DOTDOT OF RECORD
       BEGIN END VAR CONST
       IF ELSE THEN CASE FOR WHILE DO REPEAT UNTIL DOWNTO TO
       PROGRAM FUNCTION PROCEDURE
       TYPE GOTO

%token<iVal> INTEGER
%token<sVal> IDENTIFIER SYS_CON SYS_FUNCT SYS_PROC SYS_TYPE READ
%token<dVal> REAL
%token<cVal> CHAR

%type<identifier> name
%type<program> program
%type<sVal> program_head
%type<routine> routine routine_head routine_sub
%type<constDeclList> const_part const_expr_list
%type<typeDeclList> type_part type_decl_list
%type<typeDecl> type_definition
%type<varDeclList> var_part var_decl_list
%type<varDecl> var_decl
%type<routineList> routine_part
%type<constVal> const_value
%type<type> type_decl simple_type_decl array_type_decl record_type_decl
%type<nameList> name_list
%type<fieldList> field_decl_list
%type<fieldDecl> field_decl
%type<funcDecl> function_decl procedure_decl function_head procedure_head
%type<paraList> parameters para_decl_list
%type<parameter> para_type_list var_para_list val_para_list
%type<statement> stat non_label_stat else_clause proc_stat
%type<assignStat> assign_stat                      
%type<expressionList> expression_list
%type<expression> expression expr term factor
%type<argsList> args_list 
%type<ifStat> if_stat 
%type<repeatStat> repeat_stat
%type<whileStat> while_stat
%type<forStat> for_stat
%type<bVal> direction
%type<caseStat> case_stat
%type<caseExprList> case_expr_list
%type<caseExpr> case_expr
%type<gotoStat> goto_stat
%type<statementList> stat_list
%type<compoundStat> routine_body compound_stat 

%start program

%%