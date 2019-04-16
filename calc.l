%{
#include <stdio.h>
#include <string.h>
#include "calc.tab.h"
int line=1;
%}

%%

"printID" {return(TOK_PRINTID);}
"printExp" {return(TOK_PRINTExp);}

[0-9]+\.[0-9]+ {	yylval.float_val = atof(yytext);
					return TOK_FLOATNUM;	
				}
[0-9]+	{
					yylval.int_val = atoi(yytext);
					return TOK_NUM;
				}

[a-z]([A-Z]|[0-9])* { 
				strcpy(yylval.s_val,yytext);
				return TOK_ID;
			}
			
"int" { 	return(TOK_INT);			}
"float" {	return(TOK_FLOAT);			}
"{" {	return(TOK_OB);				}
"}" {	return 0;					}
"=" {	return(TOK_ASSIGN);			}
"main()" {	return(TOK_MAIN);			}	
";" {	return(TOK_SEMICOLON);		}
"-" {	return(TOK_SUB);			}
"*" {	return(TOK_MUL);			}
"E" { 	return(TOK_E);				}
[\t] {}
[ ]	{}
[\n] {(line++);}
. {printf("\nLexical Error '%c' \n",yytext[0]);}
%%

