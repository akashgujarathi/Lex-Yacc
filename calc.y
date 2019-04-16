%{
#include <stdio.h>
#include <string.h>
#include <math.h>
typedef struct IDstruct{
		char name[50];
		int ival;
		float fval;
		int type; //1=int, 2=float
}IDstruct;

typedef struct Rstruct{
	int rt;
	int rc;
}Rstruct;

int typeint[50];
int typeintcnt=0;

float typefloat[50];
int typefloatcnt;

addint(int input)
{
	typeint[typeintcnt++]=input;
}

addfloat(float input)
{
	typefloat[typefloatcnt++]=input;
}

int checkint(int input)
{
	int i,flag=0;
	for(i=0;i<typeintcnt;i++)
	{
		if(typeint[i]==input)
		{
			flag=1;
			break;
		}
	}
	if(flag==1)
	{
		return 1;
	}
	else
	{
	return 3;
	}
}


int checkfloat(float input)
{
	int i,flag=0;
	for(i=0;i<typefloatcnt;i++)
	{
		if(typefloat[i]==input)
		{
			flag=1;;
			break;
		}
	}
	if(flag==1)
	{
		return 2;
	}
	else 
	{
		return 4;
	}
}

int temp,linenum=1;
int idcnt=0;
IDstruct ids[50];	
Rstruct rs,rs1,rs2;
extern int line;

Rstruct typecheck(char n[50])
{
	int cnt=0,rtn,flag=0;
	for(cnt=0;cnt<idcnt;cnt++)
	{
		rtn=strcmp(n,ids[cnt].name);
		if(rtn==0)
		{	
			flag=1;
			break;
		}
	}
	if(flag==1)
	{
			rs.rt=ids[cnt].type;
			rs.rc=cnt;
			return rs;
	}	
}

error(int i, char n[50])
{
	switch(i)
	{
		case 1:{
			printf("Line:%d, %s already used,line: %d \n",line,n);
			break;
		}
		case 2:{
			printf("Line: %d, %s is used but not declared\n",line,n);			
			break;
		}
		case 3:{
			printf("Line: %d, type Error\n",line);
			break;
		}	
	}

	return 0;
}

%}

%token TOK_SEMICOLON TOK_ADD TOK_SUB TOK_MUL TOK_DIV TOK_NUM TOK_PRINTID TOK_MAIN
		TOK_OB TOK_INT TOK_FLOAT TOK_ID TOK_ASSIGN TOK_PRINTExp TOK_FLOATNUM
		TOK_E

%union{
			int int_val;
        	char s_val[50];
        	int line_num;
        	double float_val;
        	float e_val;
}

%type <int_val> TOK_NUM 
%type <s_val> TOK_ID
%type <float_val> TOK_FLOATNUM 
%type <e_val> expr
%left TOK_SUB
%left TOK_MUL 
%%

Prog: TOK_MAIN TOK_OB Vardefs stmt 
;

Vardefs: | Vardef TOK_SEMICOLON Vardefs
;

Vardef: TOK_INT TOK_ID 
		{
			rs1=typecheck($2);
	   		if(rs1.rt!=1 && rs1.rt!=2 )
	   		{
		   		strcpy(ids[idcnt].name,$2);	
				ids[idcnt].type=1;
				ids[idcnt++].ival=0;
	   		}
			else 
			{
				error(1,$2);
				return 0;
			}
		}
		| TOK_FLOAT TOK_ID
		{
			rs1=typecheck($2);
	   		if(rs1.rt!=1 && rs1.rt!=2 )
	   		{
				strcpy(ids[idcnt].name,$2);
				ids[idcnt].type=2;
				ids[idcnt++].fval=0.0;
			}
			else 
			{
				error(1,$2);
				return 0;
			}
		}	
;
		
stmt: 
	| stmt expr_stmt TOK_SEMICOLON
;

expr_stmt:
	   TOK_ID TOK_ASSIGN expr 
	   {
	   		rs1=typecheck($1);
				   		if(rs1.rt==1)
				   		{
				   			int x = checkint($3);
				   			if(x==1)
				   				{
				   					ids[rs1.rc].ival = (int)$3;
				   				}
				   				else
				   				{
				   					error(3,$1);
				   					return 0;
				   				}
				   		}
				   		else if(rs1.rt==2)
				   		{
				   			int x = checkfloat($3);
				   			if(x==2)
				   			{
				   				ids[rs1.rc].fval = $3;
				   			}
				   			else
				   			{
				   				error(3,$1);
				   				return 0;
				   			}
				   		}
				   		else 	
				   		{
				   			error(2,$1);
				   			return 0;
				   		}
	   }
	   | TOK_PRINTID TOK_ID 
		{
			rs1=typecheck($2);
	   		if(rs1.rt==1)
	   		{
	   			printf("%d\n",ids[rs1.rc].ival);
	   		}
	   		else if(rs1.rt==2)
	   		{
	   			printf("%.2f\n",ids[rs1.rc].fval);
	   		}
	   		else
	   		{
	   			error(1,$2);
	   			return 0;
	   		}
		}
	   | TOK_PRINTExp expr	
	   {
			fprintf(stdout, "Output: %.2f\n",$2);
	   } 
;

expr: 
	
	 TOK_ID
		{
			rs1=typecheck($1);
	   		if(rs1.rt==1)
	   		{
	   			$$=(float)ids[rs1.rc].ival;
	   			addint(ids[rs1.rc].ival);
	   		}
	   		else if(rs1.rt==2)
	   		{
	   			$$=ids[rs1.rc].fval;
	   			addfloat(ids[rs1.rc].fval);
	   		}
	   		else
	   		{
	   			error(2,$1);
	   		}
		}
	| expr TOK_SUB expr
	  {
	  	int x = checkint($1);
	  	int m = checkfloat($1);
	  	if(x==1)
	  	{
	  		int y = checkint($3);
	  		if(y==1)
	  		{
	  			$$ = $1 - $3;
	  			addint($$);
	  		}
	  		else
	  		{
	  			error(3,"");
	  			return 0;
	  		}
	  	}
	  	else if(m==2)
	  	{
	  		int n = checkfloat($3);
	  		if(n==2)
	  		{
	  			$$ = $1 - $3;
	  			addfloat($$);
	  		}
	  		else
	  		{
	  			error(3,"");
	  			return 0;
	  		}
	  	}
	  }
	| expr TOK_MUL expr
	  {
	  	int x = checkint($1);
	  	int m = checkfloat($1);
	  	if(x==1)
	  	{
	  		int y = checkint($3);
	  		if(y==1)
	  		{
	  			$$ = $1 * $3;
	  			addint($$);
	  		}
	  		else
	  		{
	  			error(3,"");
	  			return 0;
	  		}
	  	}
	  	else if(m==2)
	  	{
	  		int n = checkfloat($3);
	  		if(n==2)
	  		{
	  			$$ = $1 * $3;
	  			addfloat($$);
	  		}
	  		else
	  		{
	  			error(3,"");
	  			return 0;
	  		}
	  	}
	  }
	| TOK_NUM
	  { 	
		$$ = $1;
		addint($1);
	  } 
	| TOK_NUM TOK_E TOK_NUM 
		{	$$ = pow(10,$3);
			addfloat($$);
		} 
	| TOK_FLOATNUM TOK_E TOK_NUM 
		{	$$ = pow(10,$3);
			addfloat($$);
		}
	| TOK_FLOATNUM
	  {
	  	$$ = $1;
	  	addfloat($1);
	  }   		
;

%%

int yyerror(char *s)
{
	fprintf(stderr,"Parsing Error, Line:  %d\n",line);
	return 0;
}

int main()
{
   yyparse();
   return 0;
}
