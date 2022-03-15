%{
    #include <stdio.h>
    #include "y.tab.h"
%}

NOTE ("do"|"re"|"mi"|"fa"|"sol"|"la"|"si")
DUREE ("R"|"B"|"N")
ENTIER [1-9][0-9]*

%%
{NOTE} {
    //printf("lex->note %s\n", yytext);
    strcpy(yylval.chaine, yytext);
    return note;
}

{DUREE} {
    //printf("lex->duree %s\n", yytext);
    switch (yytext[0]) {
        case 'R':
            yylval.valeur=4;
            break;
        case 'B':
            yylval.valeur=2;
            break;
        case 'N':
            yylval.valeur=1;
            break;
    };
    return duree;
}
{ENTIER} {
    yylval.valeur=atoi(yytext);
    return repet;
}
[ |\t] ;

\n return 0;

. return yytext[0];
%%