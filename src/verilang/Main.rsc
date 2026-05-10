module Main

import Parser;
import Interpreter;
import Syntax;
import AST;
import ParseTree;
import IO;

//public void verificar(loc archivo) {
//    Tree arbol = parse(#start[Program], archivo);
//    Program ast = implode(#Program, arbol);
    
//    iprintln(ast);
//}

public void verificar(loc archivo) {
    Tree arbol = parseVeriLang(archivo); 
    Program ast = implode(#Program, arbol);
    iprintln(ast);
    runVeriLang(ast);
}

public int main(int testArgument=0) {
    println("argument: <testArgument>");
    return testArgument;
}