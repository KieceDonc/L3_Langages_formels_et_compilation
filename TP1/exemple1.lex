%{
	//Compilation
	//lex -v exemple0.lex
	//gcc -Wall lex.yy.c -o analyseur -lfl
#include <stdio.h>
int c;
%}
%%
[a-zA-Z]+(" "[a-zA-Z]+)*" "*"."$ {
    printf("Une phrase");
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
	printf("nombre lu %d\n",c);
	return 1;
}