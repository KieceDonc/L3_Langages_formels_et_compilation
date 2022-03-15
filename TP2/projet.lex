%{
    /*
    
    Autheurs : 
        - Valentin Verstracte
        - DIALLO Boubacar Biro
        - BARRY Thierno Oumar

    Compiler :
        make analyseur

    Pour tester sur un fichier :
        analyseur.o < (nom_du_fichier).txt
        
    */
    #include<stdio.h>
    
    int texte=0;
    int retour=0;
    int balise=0;
    int etle=0;
    int point=0;
    int under=0;
    int ligVide=0;
    int withDebug = 0;
%}

%%
[" "|\t] {
    printf("");
}

[^\t" "#*_\n]+[^#*_\n]* {
    texte++;
    if(withDebug){
        printf("Morceau de texte : %s\n",yytext);
    }else{
        printf("Morceau de texte\n");
    } 
}

^" "{0,3}"#"{1,6}" "+ {
    balise++;
    printf("Balise de début de titre\n");
}

\n" "*\n+ {
    ligVide++; 
    printf("Ligne vide\n"); 
}

\n|(\r\n) {
    retour++; 
    printf("Retour à la ligne simple\n");
}

^"*"" "+ {
    point++; 
    printf("Point de liste\n"); 
}

"*" {
    etle++; 
    printf("Etoile\n"); 
}

_ { 
    under++;
    printf("Underscore\n"); 
}

[^_] {
    if(withDebug){
        printf("Caractère non autorisé : %s\n", yytext);
    }else{
        printf("Caractère non autorisé\n");
    }
}
%%