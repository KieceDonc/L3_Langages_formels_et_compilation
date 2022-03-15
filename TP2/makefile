LEX_FILE = tp2.lex
LEX_FILE_COMPILED = projet.yy.c
ANALYSEUR = analyseur.o
EXEMPLE = exemple.txt
RESULTAT = resultat_compilation.txt

$(LEX_FILE_COMPILED):	$(LEX_FILE)
	lex -o $(LEX_FILE_COMPILED) -v $(LEX_FILE)

$(ANALYSEUR): $(LEX_FILE_COMPILED)
	gcc -Wall $(LEX_FILE_COMPILED) -o $(ANALYSEUR) -lfl

analyseur: $(ANALYSEUR)

test: $(ANALYSEUR) $(EXEMPLE) 
	./$(ANALYSEUR) < $(EXEMPLE)

clear: 
	(rm *.o; rm *.yy.c) 2>/dev/null || true