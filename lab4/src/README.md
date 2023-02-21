+ lex 2.5.37
+ yacc 1.9 20130304
+ 有三个命令行参数，分别是输入文件，符号表输出文件，MIPS汇编输出文件，在src文件夹下运行示例如下：
``` cmake
make
./codeGen ../tests/src0 src0.out src0.s
cd ..
./spim.linux -asm -file src/src0.s
```

+ 没有使用助教的代码，完全自己从0到750+行代码实现.
+ 但一些处理比较粗糙，使用了一些全局变量，~~现在看完全是面向测例编程~~。

