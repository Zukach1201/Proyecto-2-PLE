module Main

import Syntax;
import AST;
import ParseTree;
import IO;

public void verificar(loc archivo) {
    Tree arbol = parse(#start[Program], archivo);
    Program ast = implode(#Program, arbol);
    
    iprintln(ast);
}

public int main(int testArgument=0) {
    println("argument: <testArgument>");
    return testArgument;
}