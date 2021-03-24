%{
#include "token.h"
#include "string.h"
/* TODO: declare variables here */
%}


/* TODO: define regular expressions */
ANDnum              (&&)
ASSGNnum            (:=)
DECLARATIONSnum     (declarations)
DOTnum              (\.)
ENDDECLARATIONSnum  (enddeclarations)
EQUALnum            (=)
GTnum               (>)
INTnum              (int)
LBRACnum            (\[)
LPARENnum           (\()
METHODnum           (method)
NEnum               (\!=)
ORnum               (\|\|)
PROGRAMnum          (program)
RBRACnum            (\])
RPARENnum           (\))
SEMInum             (;)
VALnum              (val)
WHILEnum            (while)
CLASSnum            (class)
COMMAnum            (,)
DIVIDEnum           (\/\/)
ELSEnum	            (else)
EQnum               (==)
GEnum               (>=)
IFnum               (if)
LBRACEnum           (\{)
LEnum               (<=)
LTnum               (<)
MINUSnum            (-)
NOTnum              (!)
PLUSnum             (\+)
RBRACEnum           (\})
RETURNnum           (return)
TIMESnum            (\*)
VOIDnum             (void)
EOF                 (^z)
SCONSTnum           ('([^'\n\t]|\\')*')
ICONSTnum           (0|[1-9][0-9]*)
IDnum               ([a-zA-Z_][a-zA-Z0-9_]*)
BLANKSPACE          ([' '])
NEWLINE             (\n)
TAB                 (\t)
MALFORMEDID         ([0-9]*{IDnum})
UNMATCHEDS          ('[^'\n]*\n)
UNDEFINEDSYMBOL     ([|])
EOFINCOMMENT        (\/\*(".*"|[^\*]*|\*+[^\/])*)
ANNOTATION          (\/\*(".*"|[^\*]*|\*+[^\/])*\*\/)


/* TODO: define translation rules: pattern and action */
%%
{ANDnum}                    {return ANDnum; }
{ASSGNnum}                  {return ASSGNnum; }
{DECLARATIONSnum}           {return DECLARATIONSnum; }
{DOTnum}                    {return DOTnum; }
{ENDDECLARATIONSnum}        {return ENDDECLARATIONSnum; }
{EQUALnum}                  {return EQUALnum; }
{GTnum}                     {return GTnum; }
{INTnum}                    {return INTnum;  }
{LBRACnum}                  {return LBRACnum; }
{LPARENnum}                 {return LPARENnum; }
{METHODnum}                 {return METHODnum; }
{NEnum}                     {return NEnum; }
{ORnum}                     {return ORnum; }
{PROGRAMnum}                {return PROGRAMnum; }
{RBRACnum}                  {return RBRACnum; }
{RPARENnum}                 {return RPARENnum; }
{SEMInum}                   {return SEMInum; }
{VALnum}                    {return VALnum; }
{WHILEnum}                  {return WHILEnum; }
{CLASSnum}                  {return CLASSnum; }
{COMMAnum}                  {return COMMAnum; }
{DIVIDEnum}                 {return DIVIDEnum; }
{ELSEnum}		    		{return ELSEnum; }
{EQnum}                     {return EQnum; }
{GEnum}                     {return GEnum; }
{IFnum}                     {return IFnum; }
{LBRACEnum}                 {return LBRACEnum; }
{LEnum}                     {return LEnum; }
{LTnum}                     {return LTnum; }
{MINUSnum}                  {return MINUSnum; }
{NOTnum}                    {return NOTnum; }
{PLUSnum}                   {return PLUSnum; }
{RBRACEnum}                 {return RBRACEnum; }
{RETURNnum}                 {return RETURNnum; }
{TIMESnum}                  {return TIMESnum; }
{VOIDnum}                   {return VOIDnum; }
{EOF}                       {return EOF; }
{SCONSTnum}                 { return SCONSTnum; }
{IDnum}                     { return IDnum; }
{ICONSTnum}                 { return ICONSTnum; }
{MALFORMEDID}               { return MALFORMEDID; }
{UNMATCHEDS}                { return UNMATCHEDS; }
{UNDEFINEDSYMBOL}           { return UNDEFINEDSYMBOL; }
{EOFINCOMMENT}              { return EOFINCOOMMENT; }
{BLANKSPACE}                { return BLANKSPACE; }
{NEWLINE}                   { return NEWLINE; }
{TAB}                       { return TAB; }
{ANNOTATION}                { return ANNOTATION; }
%%

/* TODO: define the auxiliary functions you may use */

int yywrap() {
    return 1;
}
