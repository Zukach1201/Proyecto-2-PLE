module Main

import Parser;
import Interpreter;
import Checker;
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
    list[str] errores = checkProgram(ast);
    
    if (size(errores) > 0) {
        println("ERRORES ENCONTRADOS:");
        for (e <- errores) println("- <e>");
    } else {
        println("Todo legal. Iniciando interpretación...");
        runVeriLang(ast);
    }
}

public int main(int testArgument=0) {
    println("argument: <testArgument>");
    return testArgument;
}