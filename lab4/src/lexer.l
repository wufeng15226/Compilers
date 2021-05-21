%{
#include "proj2.h"
#include "y.tab.h"
char  strg_tbl[];
%}

ELSE	(else)

%%
{ELSE}		    			{ return (ELSEnum); }

%%

int yywrap() {
    return 1;
}
