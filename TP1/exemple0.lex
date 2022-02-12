%{
	//Compilation
	//lex -v exemple0.lex
	//gcc -Wall lex.yy.c -o analyseur -lfl
#include <stdio.h>
int c;
%}
%%
[0-9]+ { printf("[NOMBRE]");
 c++;
}
%%
int main() 
{
	c=0;
	yylex();
	return 0;
}

int yywrap()
{
	printf("nombre lu%d",c);
	return 1;
}

