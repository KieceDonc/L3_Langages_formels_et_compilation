%{
#include <stdio.h>

#include "y.tab.h"

extern int yylval;
%}

NOTE ("do"|"re"|"mi"|"fa"|"sol"|"la"|"si")
DUREE ("R"|"B"|"N")

%%
{NOTE} {
		//printf("lex->note %s\n", yytext);
		return note;
		}
{DUREE} {
		//printf("lex->duree %s\n", yytext);
		switch (yytext[0]) {
			case 'R':
				yylval=4;
				break;
			case 'B':
				yylval=2;
				break;
			case 'N':
				yylval=1;
				break;				
			};
			return duree;
			}

[ |\t] ;
\n return 0;
. return yytext[0];
%%