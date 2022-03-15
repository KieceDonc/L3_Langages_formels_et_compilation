%{
    #include <stdio.h>
    void yyerror(char * s);
%}

%token note
%token duree
%start P

%%
    P : duree note G {$$ = $1 + $3; printf("total %d\n",$$);}
    G : duree note G {$$ = $1 + $3;}
    | {$$=0;};
%%

int main(){
    yyparse();
    return 0;
}

void yyerror(char *s){
    fprintf(stderr, "erreur %s\n", s);
}