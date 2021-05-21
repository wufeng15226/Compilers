%{ /* definition */
#include "proj2.h"
#include "proj3.h"
#include <stdio.h>

tree parseTree;
extern void do_semantic(tree);
%}

%token <intg> PROGRAMnum IDnum SEMInum ELSEnum
%type <tptr> Program ClassDecl


%% /* yacc specification */
Program : PROGRAMnum IDnum SEMInum ClassDecl
        { $$ = MakeTree(ProgramOp, $4, $2); parseTree = $$; /*printtree($$, 0);*/ }
        ;

ClassDecl: IDnum /* empty for test only */
	;


%%
int yycolumn, yyline;
FILE *treelst;

main() {
   treelst = stdout;
   yyparse();

   do_semantic(parseTree);  // Do semantic analysis

   printtree(parseTree, 0); // Print the parse tree

}

yyerror(char *str) { printf("yyerror: %s at line %d\n", "", yyline); }
