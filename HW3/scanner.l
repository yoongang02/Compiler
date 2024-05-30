%{
	/* 
 	* scanner.l - lexical analyzer for the MiniC
 	* programmer - 
 	* date - 2024.04.28.
 	* 이 파일은 입력 파일의 토큰을 인식하고,
 	* 해당하는 토큰을 분류해 토큰 종류를 반환하는 렉스 파일입니다.
 	*/

    /*
    * 과제3에서의 변경사항
    * TRNUMBERER > TFNUMBERER
    * TSTAR > TMUL
    * TSLASH > TDIV
    * TLEFTPARENTHESIS > TLPAREN
    * TRIGHTPARENTHESIS > TRPAREN
    * TLEFTBRACE > TLBRACE
    * TRIGHTBRACE > TRBRACE
    * TLEFTBRACKET > TLBRACKET
    * TRIGHTBRACKET > TRBRACKET
    */

	#include <stdio.h>
	#include <stdlib.h>
    #include "tn.h"
	#include "global.h"
    #include "symtable.h"
%}

letter [A-Za-z_]
digit [0-9]
wrongchar [^ ,;!\t\n(){}\[\]&|\-=\+*/%<>] 
%%

{letter}({letter}|{digit})*								return(TIDENT);
{digit}*												return(TNUMBER);
{digit}+"."{digit}*					                    return(TFNUMBER);
"const"													return(TCONST);
"else"													return(TELSE);
"if"													return(TIF);
"int"													return(TINT);
"return"												return(TRETURN);
"void"													return(TVOID);
"while"													return(TWHILE);

"+="													return(TADDASSIGN);
"-="													return(TSUBASSIGN);
"*="													return(TMULASSIGN);
"/="													return(TDIVASSIGN);
"%="													return(TMODASSIGN);

"||"													return(TOR);
"&&"													return(TAND);
"=="													return(TEQUAL);
">"														return(TGREAT);
"<"														return(TLESS);
"!="													return(TNOTEQU);
">="													return(TGREATE);
"<="													return(TLESSE);
"++"													return(TINC);
"--"													return(TDEC);

"+"														return(TPLUS);
"-"														return(TMINUS);
"*"														return(TMUL);
"/"														return(TDIV);
"%"														return(TMOD);
"!"														return(TNOT);
"="														return(TASSIGN);
"("														return(TLPAREN);
")"														return(TRPAREN);
","														return(TCOMMA);
";"														return(TSEMICOLON);

"["														return(TLBRACKET);
"]"														return(TRBRACKET);
"{"														return(TLBRACE);
"}"														return(TRBRACE);

"//".*													;
[ \t\n]                                                 return(TWHITESPACE);

({letter}|{digit}|{wrongchar})+                         return(TERROR);
.  										         	    return(TERROR);
%%

// yywrap() - 렉서를 묶는 함수입니다. 팀원들의 이름을 출력하고 1을 리턴합니다.
int yywrap(){
	// 에러 개수 출력
    if(cErrors == 0){
        printf("No errors detected\n");
    }
    else{
        printf("%d errors detected\n", cErrors);
    }
 	printf("LeeJooHyun(1871041) JeongDaSo(2071043) YoonGyungMin(2171032) RyooEjung(2176129)\n");
	return 1;
}
