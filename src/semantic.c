#include "proj2.h"
#include "proj3.h"

// 用于查看栈内信息 for debug
extern int st_top;
void print()
{
   int i;
   for (i = 0; i < st_top + 10; i++)
   {
      printf("%d %s\n", i, getname(stack[i].name));
   }
}

extern attr_type attrarray[ATTR_SIZE];
int mainFlag;    // main是否被定义，处理单一入口问题
int stackIndTem; // 用于函数调用处理时传递stackInd来查询函数参数情况
void traverse(tree root)
{
   if (root == NullExp())
      return;
   if (root->NodeKind == EXPRNode)
   {
      int strTableInd = -1;  // 词法分析table index
      int stInd = 0;         // 符号表 index
      int argNum = 0;        // 函数参数数
      int argNumTem = 0;     // 函数参数数中间变量
      int voidFlag = false;  // 函数是否为void
      int errorFlag = 0;     // 当错误冲突时，仅报一个错误
      int dimension = 0;     // 数组维度
      int dimensionTem = 0;  // 数组维度中间变量
      tree curr = NullExp(); // 循环遍历中间变量
      switch (root->NodeOpType)
      {
      case ClassDefOp: // 类声明
         strTableInd = root->RightC->IntVal;
         if (!LookUpHere(strTableInd))
         {
            stInd = InsertEntry(strTableInd);
            SetAttr(stInd, KIND_ATTR, CLASS);
            root->RightC->NodeKind = STNode;
            root->RightC->IntVal = stInd;
            OpenBlock();
            traverse(root->LeftC);
            CloseBlock();
         }
         else
         {
            // 没有处理class重复定义的情况
         }
         break;
      case DeclOp: // 变量声明
         traverse(root->RightC->RightC->LeftC);
         strTableInd = root->RightC->LeftC->IntVal;
         stInd = LookUpHere(strTableInd);
         if (!stInd)
         {
            stInd = InsertEntry(strTableInd);
            SetAttr(stInd, TYPE_ATTR, root->RightC->RightC->LeftC); // 此属性存放了type子树指针
            root->RightC->LeftC->NodeKind = STNode;
            root->RightC->LeftC->IntVal = stInd;
            curr = root->RightC->RightC->LeftC->RightC;
            if (curr != NullExp() && curr->NodeOpType == IndexOp)
            {
               dimension = 1;
               curr = curr->RightC;
               while (curr != NullExp())
               {
                  ++dimension;
                  curr = curr->RightC;
               }
               SetAttr(stInd, KIND_ATTR, ARR);
               SetAttr(stInd, DIMEN_ATTR, dimension);
            }
            else
               SetAttr(stInd, KIND_ATTR, VAR);
         }
         else
         {
            error_msg(REDECLARATION, CONTINUE, strTableInd, true);
         }
         if (root->RightC->RightC->RightC->NodeKind == STRINGNode) // 这里暂时没有比较类型
            error_msg(STRING_ASSIGN, CONTINUE, strTableInd, true);
         traverse(root->LeftC);
         break;
      case MethodOp: // 函数声明
         strTableInd = root->LeftC->LeftC->IntVal;
         if (root->LeftC->RightC->RightC == NullExp())
            voidFlag = true; // function和procedure唯一的区别在于返回值
         stInd = LookUpHere(strTableInd);
         if (!stInd && (strcmp(getname(strTableInd), "main") || !mainFlag))
         {
            if (!strcmp(getname(strTableInd), "main"))
               mainFlag = 1;
            stInd = InsertEntry(strTableInd);
            SetAttr(stInd, KIND_ATTR, voidFlag ? PROCE : FUNC);
            SetAttr(stInd, TREE_ATTR, true);
            if (!voidFlag)
               SetAttr(stInd, TYPE_ATTR, root->LeftC->RightC->RightC);
            root->LeftC->LeftC->NodeKind = STNode;
            root->LeftC->LeftC->IntVal = stInd;

            OpenBlock();
            curr = root->LeftC->RightC->LeftC;
            while (curr != NullExp())
            {
               ++argNum;
               strTableInd = curr->LeftC->LeftC->IntVal;
               stInd = LookUpHere(strTableInd);
               if (!stInd)
               {
                  stInd = InsertEntry(strTableInd);
                  curr->LeftC->LeftC->NodeKind = STNode;
                  curr->LeftC->LeftC->IntVal = stInd;
                  SetAttr(stInd, KIND_ATTR, curr->NodeOpType == RArgTypeOp ? REF_ARG : VALUE_ARG);
               }
               else
               {
                  // 没有处理重复函数参数的情况
               }
               SetAttr(stInd, TYPE_ATTR, curr->LeftC->RightC);
               curr = curr->RightC;
            }
            SetAttr(root->LeftC->LeftC->IntVal, ARGNUM_ATTR, argNum);
            traverse(root->LeftC->RightC->RightC);
            traverse(root->RightC);
            CloseBlock();
         }
         else
         {
            error_msg(REDECLARATION, CONTINUE, strTableInd, true);
         }
         break;
      case RoutineCallOp: // 函数调用
         traverse(root->LeftC);
         argNum = attrarray[IsAttr(stackIndTem, ARGNUM_ATTR)].attr_val;
         argNumTem = 0;
         curr = root->RightC;
         while (curr != NullExp() && curr->NodeOpType == CommaOp)
         {
            ++argNumTem;
            curr = curr->RightC;
         }
         if (argNumTem != argNum)
         {
            error_msg(ARGUMENTS_NUM2, CONTINUE, attrarray[IsAttr(stackIndTem, NAME_ATTR)].attr_val, true);
         }
         traverse(root->RightC);
         break;
      case VarOp: // 变量情况
         strTableInd = root->LeftC->IntVal;
         stInd = LookUp(strTableInd);
         stackIndTem = stInd;
         if (stInd)
         {
            root->LeftC->NodeKind = STNode;
            root->LeftC->IntVal = stInd;
         }
         else
         {
            error_msg(UNDECLARATION, CONTINUE, strTableInd, true);
         }
         dimensionTem = 0;
         curr = root->RightC;
         while (curr != NullExp() && curr->NodeOpType == SelectOp)
         {
            if (curr->LeftC->NodeOpType == IndexOp)
            {
               ++dimensionTem;
               traverse(curr->LeftC->LeftC);
               curr = curr->RightC;
            }
            else if (curr->LeftC->NodeOpType == FieldOp)
            {
               strTableInd = curr->LeftC->LeftC->IntVal;
               if (attrarray[IsAttr(stInd, PREDE_ATTR)].attr_val)
               { // 预定义类的访问
                  stInd = LookUp(strTableInd);
               }
               else if (attrarray[IsAttr(stInd, TYPE_ATTR)].attr_val) // 自定义类变量的访问
               {
                  if (attrarray[IsAttr(((tree)(attrarray[IsAttr(stInd, TYPE_ATTR)].attr_val))->LeftC->IntVal, KIND_ATTR)].attr_val == CLASS) // 检查是否是class
                     stInd = LookUpField(((tree)(attrarray[IsAttr(stInd, TYPE_ATTR)].attr_val))->LeftC->IntVal, strTableInd);
                  else
                  {
                     error_msg(TYPE_MIS, CONTINUE, attrarray[IsAttr(stInd, NAME_ATTR)].attr_val, true);
                     errorFlag = 1;
                     break;
                  }
               }
               else
               { // 匿名对象的访问
                  stInd = LookUpField(stInd, strTableInd);
               }
               stackIndTem = stInd;
               if (stInd)
               {
                  curr->LeftC->LeftC->IntVal = stInd;
                  curr->LeftC->LeftC->NodeKind = STNode;
                  curr = curr->RightC;
               }
               else
               {
                  error_msg(FIELD_MIS, CONTINUE, strTableInd, true);
                  break;
               }
            }
            else
            {
               break;
            }
         }
         if (!errorFlag && attrarray[IsAttr(stInd, DIMEN_ATTR)].attr_val != dimensionTem && !attrarray[IsAttr(stInd, PREDE_ATTR)].attr_val)
         {
            if (attrarray[IsAttr(stInd, DIMEN_ATTR)].attr_val) // 数组维度错误
               error_msg(INDX_MIS, CONTINUE, strTableInd, true);
            else if (attrarray[IsAttr(stInd, TYPE_ATTR)].attr_val) // 非数组的[]非法访问
               error_msg(TYPE_MIS, CONTINUE, attrarray[IsAttr(stInd, NAME_ATTR)].attr_val, true);
         }
         break;
      case TypeIdOp: // 类型为用户自定义class时需要处理
         if (root->LeftC->NodeKind == IDNode)
         {
            strTableInd = root->LeftC->IntVal;
            stInd = LookUp(strTableInd);
            if (stInd)
            {
               root->LeftC->NodeKind = STNode;
               root->LeftC->IntVal = stInd;
            }
            else
            {
               // 没有处理class找不到的情况
            }
         }
         traverse(root->RightC);
         break;
      default:
         traverse(root->LeftC);
         traverse(root->RightC);
         break;
      }
   }
}

void do_semantic(tree parseTree)
{
   STInit();            // Initialize the symbol table
   traverse(parseTree); // Traverse tree
   // print();
   STPrint(); // Print the symbol table
}
