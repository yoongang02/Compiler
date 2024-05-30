#include <stdio.h>
#include <stdlib.h>
#include "global.h"


extern line(int);
extern yylex();


void yyerror(char *s) 
{


}


void printError(ERRORtypes err){

    switch (err)
    {
    case WrongStatement:  
        printf(lineNum+"\t");
        print("Error : Wrong Statement! \n");
        cErrors++;

        break;

    case WrongFuncDef: 
        printf(lineNum+"\t");
        print("Error : Wrong Function Definition! \n");
        cErrors++;
        break;

    case NoSemi: 
        printf(lineNum+"\t");
        print("Error : Missing Semicolon! \n");
        cErrors++;
        break;

    case NoBrace: 
        printf(lineNum+"\t");
        print("Error : Missing Brace! \n");
        cErrors++;
        break;
    
    case NoBracket: 
        printf(lineNum+"\t");
        print("Error : Missing Bracket! \n");
        cErrors++;
        break;

    default:
        break;
    }
}