

[\n ' ']+[\n ' '] { retour++; printf("Retour à la ligne simple\n"); }

"##" { balise++; printf("Balise de titre\n"); }