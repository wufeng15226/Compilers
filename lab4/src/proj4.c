#include "proj4.h"
#include <string.h>

extern attr_type attrarray[ATTR_SIZE];
int vNum; // 变量标号
int lNum; // label标号
int nest; // 嵌套层数
int symbolToLabel[ST_SIZE]; // ID转换为标号
int temLabel; // 暂存标号
int haveElse; // ifelse是否有else
int haveReturn; // 函数是否有return语句
int returnOffset; // return 类型偏移
int sameClassFun; // 这里对同类函数的访问处理很粗糙
int argPara; // 这五个均用来控制表达式的访问，封装处理得不好
int referPara;
int classPara;
int arrVar;
int haveField;
int anotherOffset; // 用来传递三层.访问的偏移量，这里也很粗糙，仅支持三层
int pushFlag = 0;  // 对象作为函数参数时，对象的变量都初始化为0，仅LI一次，其余全部push
int methodToReference[ST_SIZE]; // 通过函数ID寻找引用参数
tree classToPtr[ST_SIZE]; // 通过类ID寻找其指针

void genCode(tree root)
{
    if (root == NullExp())
        return;
    if (root->NodeKind == EXPRNode)
    {
        int stringTableID = 0;
        int type = 0;
        char value[1000] = {};
        tree currPtr = NULL;
        int argNum = 0;
        int size = 0;

        switch (root->NodeOpType)
        {
        case ProgramOp:
            fprintf(sFile, ".data\nEnter:	.asciiz	\"\n\"\nbase:\n.text\n"); // 每个汇编程序头都有的信息
            genCode(root->LeftC);
            genCode(root->RightC);
            break;
        case ClassDefOp: // class中的变量需要放在.data中
            ++nest;
            classToPtr[root->RightC->IntVal] = root;
            currPtr = root->LeftC;
            while (currPtr != NullExp() && currPtr->NodeOpType == BodyOp && currPtr->RightC->NodeOpType == MethodOp)
                currPtr = currPtr->LeftC;
            int fpOffset = 0;
            int valueOffset = 0;
            symbolToLabel[root->RightC->IntVal] = vNum;
            solveClassDecl(currPtr, value, &type, &argNum, &valueOffset, &fpOffset);
            emitData(value, type, argNum);
            genCode(root->LeftC);
            --nest;
            break;
        case MethodOp:
            ++nest;
            stringTableID = root->LeftC->LeftC->IntVal;
            if (!strcmp(getname(attrarray[IsAttr(stringTableID, NAME_ATTR)].attr_val), "main")) // main函数需要单独处理
            {
                valueOffset = 0;
                fprintf(sFile, ".text\n");
                fprintf(sFile, "main:\n");
                emitMost(LA, 0, 2, 9, vNum - 1, -1);
                stackPush(9);
                stackPush(30);
                emitMost(MOVE, 0, 2, 30, 29, -1);
                stackPush(31);
                solveMethodDecl(root->RightC->LeftC, &valueOffset);
            }
            else
            {
                valueOffset = 12;
                emitCall(stringTableID);
                symbolToLabel[stringTableID] = lNum - 1;
                solveFormalParameterList(root->LeftC->RightC->LeftC, &valueOffset, stringTableID, 1);
                valueOffset = 0;
                solveMethodDecl(root->RightC->LeftC, &valueOffset);
            }
            genCode(root->RightC->RightC);
            if(!haveReturn) emitReturn(root->LeftC->RightC->RightC!=NullExp(), 0);
            returnOffset = 0;
            haveReturn = 0;
            --nest;
            break;
        case RoutineCallOp:
            currPtr = root->LeftC;
            while (currPtr->RightC != NullExp())
            {
                currPtr = currPtr->RightC;
            }
            stringTableID = currPtr->LeftC->NodeKind == EXPRNode ? currPtr->LeftC->LeftC->IntVal : currPtr->LeftC->IntVal;
            if (attrarray[IsAttr(stringTableID, PREDE_ATTR)].attr_val)
            {
                if (!strcmp(getname(attrarray[IsAttr(stringTableID, NAME_ATTR)].attr_val), "println"))
                {
                    currPtr = root->RightC;
                    while (currPtr != NullExp() && currPtr->NodeOpType == CommaOp)
                    {
                        solveExpression(currPtr->LeftC, 1, 0);
                        currPtr = currPtr->RightC;
                    }
                    
                    if (root->RightC->LeftC->NodeKind == STRINGNode)
                    {
                        emitMost(LI, 0, 2, 2, 4, -1);
                        emitMost(LA, 0, 2, 4, vNum - 1, -1);
                        fprintf(sFile, "\tsyscall\n");
                    }
                    else
                    {
                        emitMost(LI, 0, 2, 2, 1, -1);
                        stackPop(4);
                        fprintf(sFile, "\tsyscall\n");
                        emitMost(LI, 0, 2, 2, 4, -1);
                        emitMost(LA, 0, 2, 4, -1, -1);
                        fprintf(sFile, "\tsyscall\n");
                    }
                }
                else if (!strcmp(getname(attrarray[IsAttr(stringTableID, NAME_ATTR)].attr_val), "readln"))
                {
                    emitMost(LI, 0, 2, 2, 5, -1);
                    fprintf(sFile, "\tsyscall\n");
                    currPtr = root->RightC;
                    while (currPtr != NullExp() && currPtr->NodeOpType == CommaOp)
                    {
                        solveExpression(currPtr->LeftC, 0, 1);
                        currPtr = currPtr->RightC;
                    }
                }
            }
            else
            {
                solveExpression(root->LeftC, 1, 0);
                emitMost(JAL, 0, 1, symbolToLabel[stringTableID], -1, -1);
            }
            break;
        case IfElseOp:
            if (root->RightC->NodeOpType == CommaOp)
            {
                genCode(root->LeftC);
                solveExpression(root->RightC->LeftC, 1, 0);
                stackPop(9);
                emitMost(BEQZ, 0, 2, 9, lNum + 1, -1);
                genCode(root->RightC->RightC);
                if (haveElse)
                    emitMost(B, 0, 1, temLabel, -1, -1);
                else
                    emitMost(B, 0, 1, lNum, -1, -1);
                emitLabel(++lNum, -1);
                if (!haveElse)
                    emitLabel(lNum++ - 1, -1);
            }
            else
            {
                haveElse = 1;
                temLabel = lNum;
                genCode(root->LeftC);
                genCode(root->RightC);
                emitMost(B, 0, 1, temLabel, -1, -1);
                emitLabel(temLabel, -1);
                ++lNum;
            }
            break;
        case LoopOp:
            emitLabel(++lNum, -1);
            solveExpression(root->LeftC, 1, 0);
            stackPop(9);
            emitMost(BEQZ, 0, 2, 9, lNum - 1, -1);
            genCode(root->RightC);
            emitMost(B, 0, 1, lNum, -1, -1);
            emitLabel(lNum++ - 1, -1);
            break;
        case ReturnOp:
            haveReturn = 1;
            solveExpression(root->LeftC, 1, 0);
            emitReturn(1, returnOffset);
            genCode(root->LeftC);
            break;
        case AssignOp:
            solveExpression(root->RightC, 1, 0);
            solveExpression(root->LeftC->RightC, 0, 0);
            stackPop(9);
            break;
        default:
            genCode(root->LeftC);
            genCode(root->RightC);
            break;
        }
    }
}

int getValue(tree root)
{
    if (root == NullExp())
        return 0;
    else if (root->NodeKind == NUMNode)
        return root->IntVal;
    else if (root->NodeOpType == UnaryNegOp)
        return -root->LeftC->IntVal;
    // 没有处理完
    else
        return 0;
}

char *getRegister(char *buff, int num)
{
    if (num == 2 || num == 3)
        sprintf(buff, "$v%d", num - 2);
    else if (num >= 4 && num <= 7)
        sprintf(buff, "$a%d", num - 4);
    else if (num >= 8 && num < 15)
        sprintf(buff, "$t%d", num - 8);
    else if (num == 29)
        sprintf(buff, "$sp");
    else if (num == 30)
        sprintf(buff, "$fp");
    else if (num == 31)
        sprintf(buff, "$ra");
    // 没有处理完
    return buff;
}

void stackPush(int reg)
{
    emitMost(SW, 0, 3, reg, 0, 29);
    emitMost(ADDI, 0, 3, 29, 29, -4);
}

void stackPop(int reg)
{
    emitMost(LW, 0, 3, reg, 4, 29);
    emitMost(ADDI, 0, 3, 29, 29, 4);
}

void solveClassDecl(tree root, char *arr, int *type, int *size, int *valueOffset, int *fpOffset)
{
    if (root != NullExp() && root->NodeOpType == BodyOp)
    {
        solveClassDecl(root->LeftC, arr, type, size, valueOffset, fpOffset);
        solveClassFieldDecl(root->RightC, arr, type, size, valueOffset, fpOffset);
    }
}

void solveClassFieldDecl(tree root, char *arr, int *type, int *size, int *valueOffset, int *fpOffset)
{
    if (root != NullExp() && root->NodeOpType == DeclOp)
    {
        solveClassVar(root->RightC, arr, type, size, valueOffset, fpOffset);
        solveClassFieldDecl(root->LeftC, arr, type, size, valueOffset, fpOffset);
    }
}

void solveClassVar(tree root, char *arr, int *type, int *size, int *valueOffset, int *fpOffset)
{
    if (root != NullExp() && root->NodeOpType == CommaOp)
    {
        int stringTableID = root->LeftC->IntVal;
        if(!classPara){
            SetAttr(stringTableID, OFFSET_ATTR, *fpOffset);
            symbolToLabel[stringTableID] = vNum;
        }
        *type = solveType(root->RightC->LeftC);
        if (*type == 1)
        {
            solveValue(arr, size, valueOffset, fpOffset, getValue(root->RightC->RightC));
        }
        else if (*type == 2)
        {
            *type = 1;
            if (root->RightC->RightC->RightC->NodeKind == INTEGERTNode)
            {
                int tem = root->RightC->RightC->LeftC->RightC->IntVal;
                while (tem--)
                    solveValue(arr, size, valueOffset, fpOffset, 0);
            }
            else if (root->RightC->RightC->RightC->RightC->NodeOpType == IndexOp)
            {
                solveArr1(root->RightC->RightC->LeftC, arr, size, valueOffset, fpOffset);
            }
        }
        else if(*type%10 == 0){
            tree currPtr = (classToPtr[*type/10])->LeftC;
            while (currPtr != NullExp() && currPtr->NodeOpType == BodyOp && currPtr->RightC->NodeOpType == MethodOp)
                currPtr = currPtr->LeftC;
            classPara += 1;
            solveClassDecl(currPtr, arr, type, size, valueOffset, fpOffset);
            classPara -= 1;
            *type = 1;
        }else{
            printf("ClassVar Error!%d\n", *type);
        }
    }
}

void solveArr1(tree root, char *arr, int *size, int *valueOffset, int *fpOffset)
{
    if (root != NullExp() && root->NodeOpType == CommaOp)
    {
        solveArr1(root->LeftC, arr, size, valueOffset, fpOffset);
        solveValue(arr, size, valueOffset, fpOffset, root->RightC->IntVal);
    }
}

void solveArr2(tree root, int *valueOffset)
{
    if (root != NullExp() && root->NodeOpType == CommaOp)
    {
        solveArr2(root->LeftC, valueOffset);
        emitMost(LI, 0, 2, 9, root->RightC->IntVal, -1);
        stackPush(9);
        *valueOffset -= 4;
    }
}

void solveValue(char *arr, int *size, int *valueOffset, int *fpOffset, int val)
{
    *size += 1;
    char tem[10] = {};
    sprintf(tem, "%d", val);
    strcpy(arr + *valueOffset, tem);
    *valueOffset += strlen(tem) + 1;
    *fpOffset += 4;
}

int solveType(tree root)
{
    if (root == NullExp())
    {
        printf("TypeError!\n");
        return -1;
    }
    else if (root->RightC->NodeOpType == IndexOp)
    {
        return 2; // int数组
    }
    else if (root->LeftC->NodeKind == INTEGERTNode)
    {
        return 1; // int
    }
    else if (root->NodeOpType==TypeIdOp)
    {
        return root->LeftC->IntVal*10; // class
    }
    else
    {
        printf("TypeError!(%d, %d)\n", root->NodeOpType, root->NodeKind);
        printtree(root, 0);
        return -1;
    }
}

void solveMethodDecl(tree root, int *valueOffset)
{
    if (root != NullExp() && root->NodeOpType == BodyOp)
    {
        solveMethodDecl(root->LeftC, valueOffset);
        solveMethodFieldDecl(root->RightC, valueOffset);
    }
}

void solveMethodFieldDecl(tree root, int *valueOffset)
{

    if (root != NullExp() && root->NodeOpType == DeclOp)
    {
        solveMethodVar(root->RightC, valueOffset);
        solveMethodFieldDecl(root->LeftC, valueOffset);
    }
}

void solveMethodVar(tree root, int *valueOffset)
{
    int type = solveType(root->RightC->LeftC);
    if (type == 1)
    {
        if(!classPara){
            emitMost(LI, 0, 2, 9, root->RightC->RightC->IntVal, -1);
        }else if(!pushFlag){
            pushFlag = 1;
            emitMost(LI, 0, 2, 9, 0, -1);
        }
        stackPush(9);
        *valueOffset -= 4;
    }
    else if (type == 2)
    {
        if (root->RightC->RightC->RightC->NodeKind == INTEGERTNode)
        {
            int arrSize = root->RightC->RightC->LeftC->RightC->IntVal;
            if(!pushFlag){
                pushFlag = 1;
                emitMost(LI, 0, 2, 9, 0, -1);
            }
            while (arrSize--)
            {
                stackPush(9);
                *valueOffset -= 4;
            }
        }
        else if (root->RightC->RightC->RightC->RightC->RightC->NodeOpType == IndexOp)
        {
            solveArr2(root->RightC->RightC->LeftC, valueOffset);
        }
    }else if(type%10==0){
        tree currPtr = (classToPtr[type/10])->LeftC;
        while (currPtr != NullExp() && currPtr->NodeOpType == BodyOp && currPtr->RightC->NodeOpType == MethodOp)
            currPtr = currPtr->LeftC;
        char arr[1000]={};
        int size = 0, ttype = 0, offset = 0, fpOffset=0;
        classPara += 1;
        solveMethodDecl(currPtr, valueOffset);
        classPara -= 1;
        pushFlag = 0;
        *valueOffset -= offset;
    }
    else{
        printf("method error, %d", type);
    }
    if(!classPara){
        SetAttr(root->LeftC->IntVal, OFFSET_ATTR, *valueOffset);
    }
}

void solveFormalParameterList(tree root, int* valueOffset, int stringTableID, int depth){
    if(root!=NullExp()){
        if(root->NodeOpType==RArgTypeOp){
            SetAttr(root->LeftC->LeftC->IntVal, OFFSET_ATTR, *valueOffset);
            returnOffset += 4;
            *valueOffset += 4;
            methodToReference[stringTableID] = depth;
        }else if(root->NodeOpType==VArgTypeOp){
            SetAttr(root->LeftC->LeftC->IntVal, OFFSET_ATTR, *valueOffset);
            returnOffset += 4;
            *valueOffset += 4;
        }
        solveFormalParameterList(root->RightC, valueOffset, stringTableID, depth+1);
    }
}

void solveCallParameterList(tree root, int callID, int depth){
    if(root!=NullExp()&&root->NodeOpType==CommaOp){
        solveCallParameterList(root->RightC, callID, depth+1);
        if(methodToReference[callID]==depth){
            referPara = 1;
        }
        solveExpression(root->LeftC, 1, 0);
        referPara = 0;
    }
}

void fieldAccess(int offset, int varNest, int useLabel, int load, int func, int read, tree arr, int reference, int nextOffset)
{
    if (!useLabel)
    {
        if (varNest >= nest||sameClassFun) // 访问当前块的变量或访问同类函数不需要多一次寻址，直接访问
        {
            if(reference) emitMost(LW, 0, 3, 11, offset, 30);
            else emitMost(ADD, 0, 3, 11, 30, offset);
        }
        else if (varNest == nest - 1)
        {
            emitMost(LW, 0, 3, 11, 8, 30);
            emitMost(ADD, 0, 3, 11, 11, offset);
        }
        else
        {
            printf("varNest:%d nest:%d ", varNest, nest);
            printf("nest error!\n");
        }
    }
    stackPush(11);
    emitMost(LI, 0, 2, 10, 0, -1);
    if (useLabel && !func)
        emitMost(ADD, 0, 3, 10, 10, offset);
    
    if (haveField&&(!func||nextOffset)&&!arrVar)
        emitMost(ADD, 0, 3, 10, 10, nextOffset);
    if(anotherOffset) emitMost(ADD, 0, 3, 10, 10, anotherOffset);
    if (arr->NodeOpType == IndexOp)
    {
        stackPush(10);
        arrVar = 1;
        solveExpression(arr->LeftC, 1, 0);
        arrVar = 0;
        stackPop(9);
        stackPop(10);
        emitMost(MUL, 0, 3, 9, 9, 4);
        emitMost(ADD, 1, 3, 10, 10, 9);
    }
    stackPop(11);
    if (load)
    { // 访问
        emitMost(ADD, 1, 3, 9, 11, 10);
        if (!func&&!referPara)
            emitMost(LW, 0, 3, 9, 0, 9);
        stackPush(9);
    }
    else if (read)
    { // readln
        emitMost(ADD, 1, 3, 9, 11, 10);
        emitMost(SW, 0, 3, 2, 0, 9);
    }
    else
    { // 赋值
        emitMost(ADD, 1, 3, 10, 11, 10);
        stackPop(9);
        emitMost(SW, 0, 3, 9, 0, 10);
        stackPush(9);
    }
}

void solveExpression(tree root, int load, int read)
{
    if (root == NullExp())
        return;
    else if (root->NodeKind == NUMNode)
    {
        emitMost(LI, 0, 2, 9, root->IntVal, -1);
        stackPush(9);
    }
    else if (root->NodeKind == STRINGNode)
    {
        emitStr(getname(root->IntVal));
        fprintf(sFile, ".text\n");
    }
    else if (root->NodeKind == ArrayTypeOp)
    {
        printf("array ");
    }
    else if (root->NodeOpType == VarOp)
    {
        if (attrarray[IsAttr(root->LeftC->IntVal, NEST_ATTR)].attr_val == 0) // 匿名对象的访问要通过symbolToLabel表
        {
            emitMost(LA, 1, 2, 11, symbolToLabel[root->LeftC->IntVal], -1);
            if (root->RightC!=NullExp()&&root->RightC->NodeOpType == SelectOp&&root->RightC->LeftC->NodeOpType == FieldOp)
            {
                fieldAccess(attrarray[IsAttr(root->RightC->LeftC->LeftC->IntVal, OFFSET_ATTR)].attr_val, attrarray[IsAttr(root->RightC->LeftC->LeftC->IntVal, NEST_ATTR)].attr_val, 1, load, attrarray[IsAttr(root->RightC->LeftC->LeftC->IntVal, TREE_ATTR)].attr_val, read, NullExp(), 0, -1);
            }
        }
        else
        {
            if (root->RightC!=NullExp()&&root->RightC->NodeOpType == SelectOp&&root->RightC->LeftC->NodeOpType == FieldOp)
            {
                haveField = 1;
                int stringTableID = root->RightC->LeftC->LeftC->IntVal;
                int func = attrarray[IsAttr(stringTableID, TREE_ATTR)].attr_val;
                if(root->RightC->RightC->NodeOpType==SelectOp){
                    if(root->RightC->RightC->LeftC->NodeOpType==FieldOp){
                        func = attrarray[IsAttr(root->RightC->RightC->LeftC->LeftC->IntVal, TREE_ATTR)].attr_val;
                        anotherOffset = attrarray[IsAttr(root->RightC->RightC->LeftC->LeftC->IntVal, OFFSET_ATTR)].attr_val;
                        fieldAccess(attrarray[IsAttr(root->LeftC->IntVal, OFFSET_ATTR)].attr_val, attrarray[IsAttr(root->LeftC->IntVal, NEST_ATTR)].attr_val, 0, load, func, read, NullExp(), 0, attrarray[IsAttr(stringTableID, OFFSET_ATTR)].attr_val);
                    }else if(root->RightC->RightC->LeftC->NodeOpType==IndexOp){
                        fieldAccess(attrarray[IsAttr(root->LeftC->IntVal, OFFSET_ATTR)].attr_val, attrarray[IsAttr(root->LeftC->IntVal, NEST_ATTR)].attr_val, 0, load, func, read, root->RightC->RightC->LeftC, 0, 0);
                    }
                }else{
                    fieldAccess(attrarray[IsAttr(root->LeftC->IntVal, OFFSET_ATTR)].attr_val, attrarray[IsAttr(root->LeftC->IntVal, NEST_ATTR)].attr_val, 0, load, func, read, NullExp(), 0, attrarray[IsAttr(stringTableID, OFFSET_ATTR)].attr_val);
                }
                anotherOffset = 0;
                haveField = 0;
            }else{
                fieldAccess(attrarray[IsAttr(root->LeftC->IntVal, OFFSET_ATTR)].attr_val, attrarray[IsAttr(root->LeftC->IntVal, NEST_ATTR)].attr_val, 0, load, attrarray[IsAttr(root->LeftC->IntVal, TREE_ATTR)].attr_val, read, root->RightC != NullExp() ? root->RightC->LeftC : NullExp(), attrarray[IsAttr(root->LeftC->IntVal, KIND_ATTR)].attr_val==REF_ARG, -1);
            }
        }
    }
    else if (root->NodeOpType == RoutineCallOp)
    {
        // 这里默认不是预定义函数，因为预定义函数没有返回值
        sameClassFun = 1;
        tree currPtr = root->LeftC;
        while (currPtr->RightC != NullExp())
        {
            sameClassFun = 0;
            currPtr = currPtr->RightC;
        }
        int stringTableID = currPtr->LeftC->NodeKind == EXPRNode ? currPtr->LeftC->LeftC->IntVal : currPtr->LeftC->IntVal;
        argPara = 1;
        solveCallParameterList(root->RightC, stringTableID, 1);
        argPara = 0;
        solveExpression(root->LeftC, load, read);
        emitMost(JAL, 0, 1, symbolToLabel[stringTableID], -1, -1);        
        sameClassFun = 0;
    }
    else if (root->NodeOpType == UnaryNegOp)
    {
        solveExpression(root->LeftC, load, read);
        stackPop(9);
        emitMost(LI, 0, 2, 10, 0, -1);
        emitMost(SUB, 0, 3, 9, 10, 9);
        stackPush(9);
    }
    else
    {
        solveExpression(root->LeftC, load, read);
        solveExpression(root->RightC, load, read);
        stackPop(9);
        stackPop(10);
        if (root->NodeOpType == MultOp)
            emitMost(MUL, 1, 3, 9, 10, 9);
        else if (root->NodeOpType == SubOp)
            emitMost(SUB, 1, 3, 9, 10, 9);
        else if (root->NodeOpType == AddOp)
            emitMost(ADD, 1, 3, 9, 10, 9);
        else if (root->NodeOpType == LEOp)
            emitMost(SLE, 0, 3, 9, 10, 9);
        else if (root->NodeOpType == LTOp)
            emitMost(SLT, 0, 3, 9, 10, 9);
        else if (root->NodeOpType == EQOp)
            emitMost(SEQ, 1, 3, 9, 10, 9);
        else if (root->NodeOpType == GEOp)
            emitMost(SGE, 0, 3, 9, 10, 9);
        else if (root->NodeOpType == GTOp)
            emitMost(SGT, 0, 3, 9, 10, 9);
        else
        {
            printf("expression error!(%d), ", root->NodeOpType);
            printtree(root, 0);
        }
        stackPush(9);
    }
    // 还有很多情况没有处理 LTOp
}

void emitCall(int symbolNum)
{
    fprintf(sFile, ".text\n");
    emitLabel(lNum++, symbolNum);
    stackPush(30);
    emitMost(MOVE, 0, 2, 30, 29, -1);
    stackPush(31);
}

void emitReturn(int num, int offset)
{
    emitMost(LW, 0, 3, 31, 0, 30);
    emitMost(MOVE, 0, 2, 29, 30, -1);
    emitMost(LW, 0, 3, 30, 4, 29);
    emitMost(ADDI, 0, 3, 29, 29, 4);
    emitMost(ADDI, 0, 3, 29, 29, offset+4);
    int reg = 9;
    while (num--)
    {
        stackPush(reg++);
    }
    emitMost(JR, 0, 1, 31, -1, -1);
}

void emitLabel(int num, int symbolNum)
{
    if (symbolNum != -1)
        symbolToLabel[symbolNum] = lNum;
    fprintf(sFile, "L%d:\n", num);
}

void emitData(char *dataStr, int type, int size)
{
    fprintf(sFile, ".data\nV%d:\n", vNum++);
    int offset = 0;
    while (size--)
    {
        if (type == 1)
        {
            fprintf(sFile, "\t.word\t%s\n", dataStr + offset);
            offset += strlen(dataStr + offset) + 1;
        }else{
            printf("data type error %d\n", type);
        }
        // 没有处理完
    }
}

void emitStr(char *str)
{
    fprintf(sFile, ".data\nV%d:\t.asciiz\t\"%s\"\n", vNum++, str);
}

void emitMost(int operator, int type, int numOp, int op1, int op2, int op3)
{
    char labelStr[6] = {};
    char registerStr[5] = {};
    char registerStr2[5] = {};
    char registerStr3[5] = {};

    switch (operator)
    {
    case LA:
        if (op2 == -1)
            strcpy(labelStr, "Enter");
        else
            sprintf(labelStr, "V%d", op2);
        fprintf(sFile, "\tla\t%s\t%s\n", getRegister(registerStr, op1), labelStr);
        break;
    case SW:
        fprintf(sFile, "\tsw\t%s\t%d(%s)\n", getRegister(registerStr, op1), op2, getRegister(registerStr2, op3));
        break;
    case ADDI:
        fprintf(sFile, "\taddi\t%s\t%s\t%d\n", getRegister(registerStr, op1), getRegister(registerStr2, op2), op3);
        break;
    case MOVE:
        fprintf(sFile, "\tmove\t%s\t%s\n", getRegister(registerStr, op1), getRegister(registerStr2, op2));
        break;
    case LI:
        fprintf(sFile, "\tli\t%s\t%d\n", getRegister(registerStr, op1), op2);
        break;
    case ADD:
        if (!type)
        {
            sprintf(registerStr3, "%d", op3);
        }
        else
        {
            getRegister(registerStr3, op3);
        }
        fprintf(sFile, "\tadd\t%s\t%s\t%s\n", getRegister(registerStr, op1), getRegister(registerStr2, op2), registerStr3);
        break;
    case LW:
        fprintf(sFile, "\tlw\t%s\t%d(%s)\n", getRegister(registerStr, op1), op2, getRegister(registerStr2, op3));
        break;
    case SGE:
        fprintf(sFile, "\tsge\t%s\t%s\t%s\n", getRegister(registerStr, op1), getRegister(registerStr2, op2), getRegister(registerStr3, op3));
        break;
    case BEQZ:
        fprintf(sFile, "\tbeqz\t%s\tL%d\n", getRegister(registerStr, op1), op2);
        break;
    case B:
        fprintf(sFile, "\tb\tL%d\n", op1);
        break;
    case JR:
        fprintf(sFile, "\tjr\t%s\n", getRegister(registerStr, op1));
        break;
    case MUL:
        if (!type)
        {
            sprintf(registerStr3, "%d", op3);
        }
        else
        {
            getRegister(registerStr3, op3);
        }
        fprintf(sFile, "\tmul\t%s\t%s\t%s\n", getRegister(registerStr, op1), getRegister(registerStr2, op2), registerStr3);
        break;
    case SGT:
        fprintf(sFile, "\tsgt\t%s\t%s\t%s\n", getRegister(registerStr, op1), getRegister(registerStr2, op2), getRegister(registerStr3, op3));
        break;
    case JAL:
        fprintf(sFile, "\tjal\tL%d\n", op1);
        break;
    case SLE:
        fprintf(sFile, "\tsle\t%s\t%s\t%s\n", getRegister(registerStr, op1), getRegister(registerStr2, op2), getRegister(registerStr3, op3));
        break;
    case SUB:
        fprintf(sFile, "\tsub\t%s\t%s\t%s\n", getRegister(registerStr, op1), getRegister(registerStr2, op2), getRegister(registerStr3, op3));
        break;
    case SLT:
        fprintf(sFile, "\tslt\t%s\t%s\t%s\n", getRegister(registerStr, op1), getRegister(registerStr2, op2), getRegister(registerStr3, op3));
        break;
    case SEQ:
        fprintf(sFile, "\tseq\t%s\t%s\t%s\n", getRegister(registerStr, op1), getRegister(registerStr2, op2), getRegister(registerStr3, op3));
        break;
    default:
        break;
    }
}