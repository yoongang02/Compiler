#include <stdio.h>
#include <stdlib.h>
#include "tn.h"
#include "glob.h"

extern int yyparse();

int main()
{
    printf("\n\t[Error Report : Error Information]\n");
    printf("===============================================");
    lineNum = 1;
    yyparse();

    if(cErrors == 0) printf("\n\t No error detected!\n");
    else printf("\n\t %d error(s) detected!",cErrors);

    
    printf("===============================================");
    PrintHStable();
    printf("LeeJooHyun(1871041) JeongDaSo(2071043) YoonGyungMin(2171032) RyooEjung(2176129)\n");
}