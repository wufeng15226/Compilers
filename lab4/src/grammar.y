%{ /* definition */
#include "proj2.h"
#include "proj3.h"
#include <stdio.h>

tree typePtr; // 用来传递type指针的全局变量
tree parseTree;
extern void do_semantic(tree);
%}

%token <intg> ANDnum ASSGNnum DECLARATIONSnum DOTnum ENDDECLARATIONSnum EQUALnum GTnum IDnum INTnum LBRACnum LPARENnum METHODnum NEnum ORnum PROGRAMnum RBRACnum RPARENnum SEMInum VALnum WHILEnum CLASSnum COMMAnum DIVIDEnum ELSEnum EQnum GEnum ICONSTnum IFnum LBRACEnum LEnum LTnum MINUSnum NOTnum PLUSnum RBRACEnum RETURNnum SCONSTnum TIMESnum VOIDnum EOFnum MALFORMEDID UNMATCHEDS UNDEFINEDSYMBOL EOFINCOOMMENT BLANKSPACE NEWLINE TAB ANNOTATION
%type <tptr> Program _ClassDecl ClassDecl ClassBody _MethodDecl Decls _FieldDecl FieldDecl VariableDeclId _VariableDeclId __VariableDeclId ___VariableDeclId VariableInitializer _ArrayInitializer ArrayInitializer ArrayCreationExpression _ArrayCreationExpression MethodDecl FormalParameterList _FormalParameterList _FormalParameterList1 _FormalParameterList2 Block Type _Type __Type StatementList _Statement Statement AssignmentStatement MethodCallStatement ReturnStatement IfStatement _IfStatement WhileStatement Expression _Expression1 _Expression2 SimpleExpression Term _Term Factor _Factor UnsignedConstant Variable _Variable

%% /* yacc specification */
Program: PROGRAMnum IDnum SEMInum _ClassDecl { $$ = MakeTree(ProgramOp, $4, NullExp()); parseTree = $$; /*printtree($$, 0);*/ }
        ;

/* 以_或__开头的非终结符都是用于辅助循环 */
_ClassDecl: _ClassDecl ClassDecl { $$ = MakeTree(ClassOp, $1, $2); }
        | ClassDecl { $$ = MakeTree(ClassOp, NullExp(), $1); }
        ;

ClassDecl: CLASSnum IDnum ClassBody { $$ = MakeTree(ClassDefOp, $3, MakeLeaf(IDNode, $2)); }
	;

ClassBody: LBRACEnum RBRACEnum { $$ = NullExp(); }
        | LBRACEnum Decls RBRACEnum { $$ = $2; }
        | LBRACEnum Decls _MethodDecl RBRACEnum { $$ = MkLeftC($2, $3); }
        | LBRACEnum _MethodDecl RBRACEnum { $$ = $2; }
        ;

_MethodDecl: _MethodDecl MethodDecl { $$ = MakeTree(BodyOp, $1, $2); }
        | MethodDecl { $$ = MakeTree(BodyOp, NullExp(), $1); }
        ;

Decls: DECLARATIONSnum ENDDECLARATIONSnum { $$ = MakeTree(BodyOp, NullExp(), NullExp()); } /* 虽然没有变量定义，但还是用一个子树表示该定义的存在 */
        | DECLARATIONSnum _FieldDecl ENDDECLARATIONSnum { $$ = $2; }
        ;

_FieldDecl: _FieldDecl FieldDecl { $$ = MakeTree(BodyOp, $1, $2); }
        | FieldDecl { $$ = MakeTree(BodyOp, NullExp(), $1); }
        ;

FieldDecl: Type _VariableDeclId SEMInum { $$ = $2; }
        ;

_VariableDeclId: __VariableDeclId { $$ = MakeTree(DeclOp, NullExp(), $1); }
        | _VariableDeclId COMMAnum __VariableDeclId { $$ = MakeTree(DeclOp, $1, $3); }
        ;

/* 这里用到了之前存储的typeptr */
__VariableDeclId: VariableDeclId { $$ = MakeTree(CommaOp, $1, MakeTree(CommaOp, typePtr, NullExp())); }
        | VariableDeclId EQUALnum VariableInitializer { $$ = MakeTree(CommaOp, $1, MakeTree(CommaOp, typePtr, $3)); }
        ;

VariableDeclId: IDnum ___VariableDeclId { $$ = MakeLeaf(IDNode, $1); }
        ;

/* 这里对多个[]的处理是一样的 */
___VariableDeclId: ___VariableDeclId LBRACnum RBRACnum {}
        | LBRACnum RBRACnum {}
        | {}
        ;

VariableInitializer: Expression { $$ = $1; }
        | ArrayInitializer { $$ = $1; }
        | ArrayCreationExpression { $$ = $1; }
        ;

/* 这里用到了之前存储的typeptr */
ArrayInitializer: LBRACEnum _ArrayInitializer RBRACEnum { $$ = MakeTree(ArrayTypeOp, $2, typePtr); }
        ;

_ArrayInitializer: _ArrayInitializer COMMAnum VariableInitializer { $$ = MakeTree(CommaOp, $1, $3); }
        | VariableInitializer { $$ = MakeTree(CommaOp, NullExp(), $1); }
        ;

ArrayCreationExpression: INTnum _ArrayCreationExpression { $$ = MakeTree(ArrayTypeOp, $2, MakeLeaf(INTEGERTNode, $1)); }
        ;

_ArrayCreationExpression: _ArrayCreationExpression LBRACnum Expression RBRACnum { $$ = MakeTree(BoundOp, $1, $3); }
        | LBRACnum Expression RBRACnum { $$ = MakeTree(BoundOp, NullExp(), $2);; }
        ;

/* 这里用到了之前存储的typeptr */
MethodDecl: METHODnum Type IDnum LPARENnum FormalParameterList RPARENnum Block { typePtr = $2; $$ = MakeTree(MethodOp, MakeTree(HeadOp, MakeLeaf(IDNode, $3), $5), $7); }
        ;

/* 这里用到了之前存储的typeptr */
FormalParameterList: _FormalParameterList { $$ = MakeTree(SpecOp, $1, typePtr); }
        ;

/* 这里把按值和引用传递分别处理 */
_FormalParameterList: INTnum _FormalParameterList1 { $$ = $2; }
        | VALnum INTnum _FormalParameterList2 { $$= $3; }
        | INTnum _FormalParameterList1 SEMInum _FormalParameterList { $$ = MkRightC($4, $2); }
        | VALnum INTnum _FormalParameterList2 SEMInum _FormalParameterList { $$= MkRightC($5, $3); }
        | { $$ = NullExp(); }
        ;

_FormalParameterList1: IDnum COMMAnum _FormalParameterList1 { $$ = MakeTree(RArgTypeOp, MakeTree(CommaOp, MakeLeaf(IDNode, $1), MakeLeaf(INTEGERTNode, NullExp())), $3); }
        | IDnum { $$ = MakeTree(RArgTypeOp, MakeTree(CommaOp, MakeLeaf(IDNode, $1), MakeLeaf(INTEGERTNode, NullExp())), NullExp()); }
        ;

_FormalParameterList2: IDnum COMMAnum _FormalParameterList2 { $$ = MakeTree(VArgTypeOp, MakeTree(CommaOp, MakeLeaf(IDNode, $1), MakeLeaf(INTEGERTNode, NullExp())), $3); }
        | IDnum { $$ = MakeTree(VArgTypeOp, MakeTree(CommaOp, MakeLeaf(IDNode, $1), MakeLeaf(INTEGERTNode, NullExp())), NullExp()); }
        ;


Block: Decls StatementList { $$ = MakeTree(BodyOp, $1, $2); }
        | StatementList { $$ = MakeTree(BodyOp, NullExp(), $1); }
        ;

/* type处理结束后需要把指针存放在typeptr处 */
Type: _Type { $$ = $1; typePtr = $$; }
        | _Type DOTnum Type { $$ = MkRightC(MakeTree(FieldOp, $3, NullExp()), $1); typePtr = $$; }
        | VOIDnum { $$ = NullExp(); typePtr = $$; }
        ;

_Type: IDnum __Type { $$ = MakeTree(TypeIdOp, MakeLeaf(IDNode, $1), $2); }
        | INTnum __Type { $$ = MakeTree(TypeIdOp, MakeLeaf(INTEGERTNode, $1), $2); }
        ;

/* 这里每出现一次[]就多一个IndexOp结点 */
__Type: __Type LBRACnum RBRACnum { $$ = MakeTree(IndexOp, NullExp(), $1); }
        | LBRACnum RBRACnum { $$ = MakeTree(IndexOp, NullExp(), NullExp()); }
        | { $$ = NullExp(); }
        ;

StatementList: LBRACEnum _Statement RBRACEnum { $$ = $2; }
        | LBRACEnum RBRACEnum { $$ = MakeTree(StmtOp, NullExp(), NullExp()); }
        ;

_Statement: _Statement Statement SEMInum { $$ = MakeTree(StmtOp, $1, $2); }
        | Statement SEMInum { $$ = MakeTree(StmtOp, NullExp(), $1); }
        ;

Statement: AssignmentStatement { $$ = $1; }
        | MethodCallStatement { $$ = $1; }
        | ReturnStatement { $$ = $1; }
        | IfStatement { $$ = $1; }
        | WhileStatement { $$ = $1; }
        | { $$ = NullExp(); }
        ;

AssignmentStatement: Variable ASSGNnum Expression { $$ = MakeTree(AssignOp, MakeTree(AssignOp, NullExp(), $1), $3); }
        ;

MethodCallStatement: Variable LPARENnum RPARENnum { $$ = MakeTree(RoutineCallOp, $1, NullExp()); }
        | Variable LPARENnum _Expression2 RPARENnum { $$ = MakeTree(RoutineCallOp, $1, $3); }
        ;

ReturnStatement: RETURNnum { $$ = MakeTree(ReturnOp, NullExp(), NullExp()); }
        | RETURNnum Expression { $$ = MakeTree(ReturnOp, $2, NullExp()); }
        ;

IfStatement: _IfStatement { $$ = $1; }
        | _IfStatement ELSEnum StatementList { $$ = MakeTree(IfElseOp, $1, $3); }

_IfStatement: _IfStatement ELSEnum IFnum Expression StatementList  { $$ = MakeTree(IfElseOp, $1, MakeTree(CommaOp, $4, $5)); }
        | IFnum Expression StatementList { $$ = MakeTree(IfElseOp, NullExp(), MakeTree(CommaOp, $2, $3)); }
        ;

WhileStatement: WHILEnum Expression StatementList { $$ = MakeTree(LoopOp, $2, $3); }
        ;

Expression: SimpleExpression { $$ = $1; }
        | SimpleExpression LTnum SimpleExpression { $$ = MakeTree(LTOp, $1, $3); }
        | SimpleExpression LEnum SimpleExpression { $$ = MakeTree(LEOp, $1, $3); }
        | SimpleExpression EQnum SimpleExpression { $$ = MakeTree(EQOp, $1, $3); }
        | SimpleExpression NEnum SimpleExpression { $$ = MakeTree(NEOp, $1, $3); }
        | SimpleExpression GEnum SimpleExpression { $$ = MakeTree(GEOp, $1, $3); }
        | SimpleExpression GTnum SimpleExpression { $$ = MakeTree(GTOp, $1, $3); }
        ;

SimpleExpression: Term { $$ = $1; }
        | PLUSnum Term { $$ = $2; }
        | MINUSnum Term { $$ = MakeTree(UnaryNegOp, $2, NullExp()); }
        | Term _Term { $$ = MkLeftC($1, $2); }
        | PLUSnum Term _Term { $$ = MkLeftC($2, $3); }
        | MINUSnum Term _Term {  $$ = MkLeftC(MakeTree(UnaryNegOp, $2, NullExp()), $3); }
        ;

_Term: _Term PLUSnum Term { $$ = MakeTree(AddOp, $1, $3); }
        | _Term MINUSnum Term { $$ = MakeTree(SubOp, $1, $3); }
        | _Term ORnum Term { $$ = MakeTree(OrOp, $1, $3); }
        | { $$ = NullExp(); }
        ;

Term: Factor { $$ = $1; }
        | Factor _Factor { $$ = MkLeftC($1, $2); }
        ;

_Factor: TIMESnum Factor _Factor { $$ = MakeTree(MultOp, $3, $2); }
        | DIVIDEnum Factor _Factor { $$ = MakeTree(DivOp, $3, $2); }
        | ANDnum Factor _Factor { $$ = MakeTree(AndOp, $3, $2); }
        | { $$ = NullExp(); }
        ;

Factor: UnsignedConstant { $$ = $1; }
        | Variable { $$ = $1; }
        | MethodCallStatement { $$ = $1; }
        | LPARENnum Expression RPARENnum { $$ = $2; }
        | NOTnum Factor { $$ = $2; } 
        ;

UnsignedConstant: ICONSTnum { $$ = MakeLeaf(NUMNode, $1); }
        | SCONSTnum { $$ = MakeLeaf(STRINGNode, $1); }
        ;

Variable: IDnum _Variable { $$ = MakeTree(VarOp, MakeLeaf(IDNode, $1), $2); }
        | IDnum { $$ = MakeTree(VarOp, MakeLeaf(IDNode, $1), NullExp()); }
        ;

_Variable: LBRACnum _Expression1 RBRACnum _Variable { $$ = MakeTree(SelectOp, $2, $4); }
        | DOTnum IDnum _Variable { $$ = MakeTree(SelectOp, MakeTree(FieldOp, MakeLeaf(IDNode, $2), NullExp()), $3); }
        | LBRACnum _Expression1 RBRACnum { $$ = MakeTree(SelectOp, $2, NullExp()); }
        | DOTnum IDnum { $$ = MakeTree(SelectOp, MakeTree(FieldOp, MakeLeaf(IDNode, $2), NullExp()), NullExp()); }
        ;


/* 针对Expression循环时生成的不同结点，分别处理 */
_Expression1: Expression COMMAnum _Expression1 { $$ = MakeTree(IndexOp, $1, $3); }
        | Expression { $$ = MakeTree(IndexOp, $1, NullExp()); }
        ;

_Expression2: Expression COMMAnum _Expression2{ $$ = MakeTree(CommaOp, $1, $3); }
        | Expression { $$ = MakeTree(CommaOp, $1, NullExp()); }
        ;

%%
extern int yycolumn, yyline;
extern char* yytext;
extern int yyleng;
extern FILE* yyin;
extern FILE* yyout;
FILE* outFile;
FILE* treelst;
FILE* sFile;
int main(int argc, char** argv) {

        if(argc!=4){
		printf("没有文件\n");
        }
	
        // File open
        FILE* inFile = fopen(argv[1], "r");
	if(!inFile) printf("inFile open error!\n");
	outFile = fopen(argv[2], "w+");
	if(!outFile) printf("outFile open error!\n");
	sFile = fopen(argv[3], "w+");
	if(!sFile) printf("Assembly File open error!\n");
	
        yyin = inFile;
        treelst = outFile;
        // treelst = stdout;
        yyparse();
        do_semantic(parseTree);  // Do semantic analysis
        genCode(parseTree);		// Generate target code (proj4.[h|c])
        STPrint(); // Print the symbol table
        // printtree(parseTree, 0); // Print the parse tree

        // File close
	fclose(inFile);
	fclose(outFile);
        fclose(sFile);
	
        return 0;
}

yyerror(char *str) { printf("yyerror: ‘%s’ at line %d column %d.\n", yytext, yyline, yycolumn-yyleng); }
