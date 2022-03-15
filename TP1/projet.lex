%{
	   #include<stdio.h>
       int texte=0;
       int retour=0;
       int balise=0;
       int etle=0;
       int point=0;
       int under=0;
       int ligVide=0;
%}
%%
[^" "\t][^#*_\n] { texte++; printf("Morceau de texte\n"); }

" "{0,3}"#"{1,6}" "+ {
    balise++;
    printf("Balise de titre\n");
}

\n" "*\n+ { ligVide++; printf("Ligne vide\n"); }

\n|\r\n {
    retour++; printf("Retour à la ligne simple\n");
}

"*"" "+ { point++; printf("Point de liste\n"); }

"*" { etle++; printf("Etoile\n"); }

_ { under++; printf("Underscore\n"); }
%%
 int main(){
    yylex(); 
    printf("\n");printf("\n");printf("\n");printf("\n");
    return 0;   
}
int yywrap(){ 
  return 1; 
}