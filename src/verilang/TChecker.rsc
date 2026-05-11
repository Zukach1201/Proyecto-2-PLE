module TChecker

import Syntax;
import AST;
extend analysis::typepal::Typepal;

// 1. Definimos los roles de VeriLang
data IdRole = varId() | spaceId();

// 2. Función principal que pide el tutorial
public TModel checkVeriLang(Tree pt) {
    c = newCollector("VeriLangChecker", pt);
    collect(pt, c);
    return newSolver(pt, c.run()).run();
}

// 3. Recolectar variables (Esto reemplaza tu defvar manual)
void collect(current: (Var) `<Type t> <Identifier id1> : <Identifier id2>`, Collector c) {
    c.define("<id1>", varId(), id1, defType(toVType(t))); 
}

// 4. Usar variables (Esto verifica que existan)
void collect(current: (AtomicExp) `<Identifier id>`, Collector c) {
    c.use(id, {varId()});
}