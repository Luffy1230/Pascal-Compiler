%{
#include <stdio.h>
#include <string>
#include "ast.h"
//#include "parser.hpp"
extern "C" int yywrap() {return 1;}
%}

%%
[ \t\n]                                                 { ; }
\'.\'                                                   { 
                                                            yylval.cVal = yytext[1];
                                                            return CHAR; 
                                                        }
"("                                                     { return LP; }
")"                                                     { return RP; }
"["                                                     { return LB; }
"]"                                                     { return RB; }
"."                                                     { return DOT; }
","                                                     { return COMMA; }
":"                                                     { return COLON; }
";"                                                     { return SEMI; }
"+"                                                     { return PLUS; }
"-"                                                     { return MINUS; }
"*"                                                     { return MUL; }
"/"                                                     { return DIV; }
"div"                                                   { return DIV; }
"mod"                                                   { return MOD; }
"="                                                     { return EQUAL; }
"<>"                                                    { return UNEQUAL; }
"not"                                                   { return NOT; }
"and"                                                   { return AND; }
"or"                                                    { return OR; }
">="                                                    { return GE; }
">"                                                     { return GT; }
"<="                                                    { return LE; }
"<"                                                     { return LT; }
":="                                                    { return ASSIGN; }
"array"                                                 { return ARRAY; }
".."                                                    { return DOTDOT; }
"of"                                                    { return OF; }
"record"                                                { return RECORD; }
"begin"                                                 { return TOKEN_BEGIN; }
"end"                                                   { return END; }
"var"                                                   { return VAR; }
"const"                                                 { return CONST; }
"if"                                                    { return IF; }
"else"                                                  { return ELSE; }
"then"                                                  { return THEN; }
"case"                                                  { return CASE; }
"for"                                                   { return FOR; }
"while"                                                 { return WHILE; }
"do"                                                    { return DO; }
"repeat"                                                { return REPEAT; }
"until"                                                 { return UNTIL; }
"downto"                                                { return DOWNTO; }
"to"                                                    { return TO; }
"program"                                               { return PROGRAM; }
"procedure"                                             { return PROCEDURE; }
"function"                                              { return FUNCTION; }
"goto"                                                  { return GOTO; }
"type"                                                  { return TYPE; }



"boolean"|"char"|"integer"|"real"                       {
                                                            yylval.sVal = new std::string(yytext, yyleng); 
                                                            return SYS_TYPE; 
                                                        }
"abs"|"chr"|"odd"|"ord"|"pred"|"sqr"|"sqrt"|"succ"      {
                                                            yylval.sVal = new std::string(yytext, yyleng); 
                                                            return SYS_FUNCT; 
                                                        }
"false"|"maxint"|"true"                                 {
                                                            yylval.sVal = new std::string(yytext, yyleng); 
                                                            return SYS_CON; 
                                                        }
"write"|"writeln"                                       { 
                                                            yylval.sVal = new std::string(yytext, yyleng);
                                                            return SYS_PROC; 
                                                        }
"read"                                                  { 
                                                            yylval.sVal = new std::string(yytext, yyleng);
                                                            return READ; 
                                                        }

[a-zA-Z_][a-zA-Z0-9_]*                                  { 
                                                            yylval.sVal = new std::string(yytext, yyleng);
                                                            return IDENTIFIER; 
                                                        } 
[0-9]+\.[0-9]+                                          { 
                                                            double dtmp;
                                                            sscanf(yytext, "%lf", &dtmp);
                                                            yylval.dVal = dtmp;
                                                            return REAL; 
                                                        }
[0-9]+                                                  {
                                                            int itmp;                                                           double tmp;
                                                            sscanf(yytext, "%d", &itmp);
                                                            yylval.iVal = itmp; 
                                                            return INTEGER; 
                                                        }



%%
