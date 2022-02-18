Autheurs : 
  - Valentin Verstracte
  - DIALLO Boubacar Biro
  - BARRY Thierno Oumar

Compiler :
  Avec le makefile:
    make analyseur
  
  Sans le makefile:
    lex -o projet.yy.c -v projet.lex
	  gcc -Wall projet.yy.c -o analyseur.o -lfl

Pour tester sur un fichier :
  analyseur.o < (nom_du_fichier).txt