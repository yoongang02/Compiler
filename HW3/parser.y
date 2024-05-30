%{
/*    parser.y - YACC source for the MiniC
*
*    Programmer -
*
*    date - 
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <malloc.h>
#include <symtable.h>	
#include "global.h"

void line(int);
extern printError();
extern yylex();
extern yyerror(s);
%}

%token TIDENT TNUMBER TFNUMBER TCONST TELSE TIF TINT TRETURN TVOID TWHILE
%token TADDASSIGN TSUBASSIGN TMULASSIGN TDIVASSGIN TMODASSIGN
%token TOR TAND TEQUAL TNOTEQU TGREAT TLESS TGREATE TLESSE TINC TDEC
%token TPLUS TMINUS TMUL TDIV TMOD TNOT TASSIGN TLPAREN TRPAREN TCOMMA TSEMICOLON
%token TLBRACKET TRBRACKET TLBRACE TRBRACE
%nonassoc TLOWER_THEN_ELSE
%nonassoc TELSE

%%
mini_c              : translation_unit			                            ;
translation_unit 	: external_dcl				                            
			        | translation_unit external_dcl	                        ;
external_dcl 		: function_def				                            
		  	        | declaration				                            ;
function_def 		: function_header compound_st		                    ;
function_header 	: dcl_spec function_name formal_param	                ;
dcl_spec 		    : dcl_specifiers			                            ;
dcl_specifiers 		: dcl_specifier				                            
		 	        | dcl_specifiers dcl_specifier		                    ;
dcl_specifier 		: type_qualifier				                        
			        | type_specifier			                            ;
type_qualifier 		: TCONST				                                
					{
						//const 임.
						tmp_is_const = 1;
					};
type_specifier 		: TINT					                                
					{
						//int
						tmp_type_detail = 1;
					}
					| TFNUMBER
					{
						//float
						tmp_type_detail = 2;
					}
		 	        | TVOID
					{
						//void
						tmp_type_detail = 3;
					};				                                
function_name 	    : TIDENT					                            
					{
						//함수이다.
						tmp_type = 2;
						yytext = $1;
						yyleng = strlen(yytext);
						tmp_func_name = yytext;
						SymbolTable();
					};
formal_param 		: TLPAREN opt_formal_param TRPAREN 		                ;
opt_formal_param 	: formal_param_list			                            
		   	        |					                                    ;
formal_param_list 	: param_dcl				                                
		    	    | formal_param_list TCOMMA param_dcl 	                ;
param_dcl 		    : dcl_spec declarator			                        
					{
						//함수 파라미터
						tmp_is_param = 1;
						//변수
						tmp_type = 1;
					};
compound_st 		: TLBRACE opt_dcl_list opt_stat_list TRBRACE 	                ;
opt_dcl_list 		: declaration_list			                            
			        |					                                    ;
declaration_list 	: declaration				                            
			        | declaration_list declaration 		                    ;
declaration 		: dcl_spec init_dcl_list TSEMICOLON		                 ;
init_dcl_list 		: init_declarator			                            
			        | init_dcl_list TCOMMA init_declarator 	                ;
init_declarator 	: declarator					                        
					| declarator TASSIGN TFNUMBER
		 	        | declarator TASSIGN TNUMBER		                      ;
declarator 		    : TIDENT					                            
					{ 
						//스칼라 변수
						tmp_var_type = 1;
						yytext = $1;
						yyleng = strlen(yytext);
						SymbolTable();
					}
	     		    | TIDENT TLBRACKET opt_number TRBRACKET		            
					{
						//배열 변수
						tmp_var_type = 2;
						yytext = $1;
						yyleng = strlen(yytext);
						SymbolTable();
					};
opt_number 		    : TNUMBER				                                
					| TFNUMBER
	     		    |					                                    ;
opt_stat_list 		: statement_list			                            
		 	        |					                                    ;
statement_list 		: statement				                                
		 	        | statement_list statement 		                        ;
statement 		    : compound_st			                                
	   		        | expression_st			                                
	   		        | if_st					                               
	   		        | while_st				                               
	   		        | return_st				                                
	   		        ;
expression_st 	    : opt_expression TSEMICOLON			                     ;
opt_expression 	    : expression				                           
		 	        |					                                  ;
if_st 			    : TIF TLPAREN expression TRPAREN statement %prec TLOWER_THEN_ELSE 
			        | TIF TLPAREN expression TRPAREN statement TELSE statement 	   ;
while_st 		    : TWHILE TLPAREN expression TRPAREN statement 	                ;
return_st 		    : TRETURN opt_expression TSEMICOLON		                ;
expression 		    : assignment_exp			                            ;
assignment_exp 	    : logical_or_exp			                           
			        | unary_exp TASSIGN assignment_exp 		                   
			        | unary_exp TADDASSIGN assignment_exp 	              
			        | unary_exp TSUBASSIGN assignment_exp 	                
			        | unary_exp TMULASSIGN assignment_exp 	                
			        | unary_exp TDIVASSGIN assignment_exp 	           
			        | unary_exp TMODASSIGN assignment_exp 	              
			        ;
logical_or_exp 	    : logical_and_exp			                           
			        | logical_or_exp TOR logical_and_exp 	             ;
logical_and_exp 	: equality_exp				                          
		 	        | logical_and_exp TAND equality_exp 	       ;
equality_exp 		: relational_exp			                            
			        | equality_exp TEQUAL relational_exp 	          
			        | equality_exp TNOTEQU relational_exp 	                ;
relational_exp 	    : additive_exp 			                              
			        | relational_exp TGREAT additive_exp 	                    
			        | relational_exp TLESS additive_exp 	                    
			        | relational_exp TGREATE additive_exp 	               
			        | relational_exp TLESSE additive_exp 	               ;
additive_exp 		: multiplicative_exp			                        
			        | additive_exp TPLUS multiplicative_exp 	              
			        | additive_exp TMINUS multiplicative_exp 	             ;
multiplicative_exp 	: unary_exp				                               
		    	    | multiplicative_exp TMUL unary_exp 	                 
		    	    | multiplicative_exp TDIV unary_exp 	                  
		    	    | multiplicative_exp TMOD unary_exp 	                 ;
unary_exp 		    : postfix_exp				                       
	   		        | TMINUS unary_exp				                        
	   		        | TNOT unary_exp				                            
	   		        | TINC unary_exp			                     
	   		        | TDEC unary_exp			                            ;
postfix_exp 		: primary_exp				                           
	      		    | postfix_exp TLBRACKET expression TRBRACKET 	                   
	      		    | postfix_exp TLPAREN opt_actual_param TRPAREN 	             
	      		    | postfix_exp TINC			                          
	      		    | postfix_exp TDEC			                         ;
opt_actual_param 	: actual_param				                          
		  	        |					                               ;
actual_param 		: actual_param_list			                          ;
actual_param_list 	: assignment_exp			                          
		   	        | actual_param_list TCOMMA assignment_exp 	            ;
primary_exp 		: TIDENT				                            
	     		    | TNUMBER
					| TFNUMBER				                              
	     		    | TLPAREN expression TRPAREN			                   ;
%%
