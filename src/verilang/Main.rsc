module Main

import Syntax;
import AST;
import ParseTree;
import IO;

/* 
  Esta función toma la ubicación de un archivo .vl, 
  lo convierte en un árbol de sintaxis y luego en un AST.
*/
void verificar(loc archivo) {
    // 1. Intentar el parseo (esto verifica la gramática y precedencia)
    println("Parseando archivo...");
    arbol = parse(#start[Program], archivo);
    
    // 2. Intentar el implode (esto verifica que Syntax y AST coincidan)
    println("Generando AST...");
    ast = implode(#Program, arbol);
    
    // 3. Mostrar el resultado
    println("¡Éxito! Este es tu AST:");
    iprintln(ast);
}

int main(int testArgument=0) {
    println("argument: <testArgument>");
    return testArgument;
}
