y.tab.c: projet.yacc
	yacc projet.yacc

y.tab.h: projet.yacc
	yacc -d projet.yacc

lex.yy.c: projet.lex 
	lex projet.lex

lex.yy.o: lex.yy.c y.tab.h
	gcc -g -Wall -c lex.yy.c

analyseur: y.tab.c lex.yy.o
	gcc -g -Wall y.tab.c lex.yy.o -lfl -o analyseur.o

test: analyseur test.txt
	./analyseur.o < test.txt

clear:
	(rm y.tab.h; rm y.tab.c; rm lex.yy.c: rm *.o; rm analyseur;) 2> /dev/null