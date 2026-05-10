module Interpreter

import AST;
import IO;
import Boolean;
import String;

data Value 
    = vInt(int n)
    | vBool(bool b) 
    | vFloat(real r)
    | vString(str s)
    | vUnknown();

alias Env = map[str, Value];


public Value eval(exprAtomic(atomicexp(str id)), Env env) = env[id] ? vUnknown(); 
public Value eval(exprAtomic(atomicexpsimple(intliteral(int n))), Env env) = vInt(n);
public Value eval(exprAtomic(atomicexpsimple(boolliteral(bool b))), Env env) = vBool(b);

public Value eval(exprParen(Expr e), Env env) = eval(e, env);

public Value eval(exprUnary(neg(), Expr e), Env env) {
    if (vBool(bool b) := eval(e, env)) return vBool(!b);
    throw "Error: NEG solo funciona con valores Booleanos";
}

public Value eval(exprAdd(Expr l, Expr r), Env env) {
    if (vInt(int i1) := eval(l, env), vInt(int i2) := eval(r, env)) return vInt(i1 + i2);
    throw "Error de tipos en suma";
}

public Value eval(exprMul(Expr l, Expr r), Env env) {
    if (vInt(int i1) := eval(l, env), vInt(int i2) := eval(r, env)) return vInt(i1 * i2);
    throw "Error de tipos en multiplicación";
}

public Value eval(exprSub(Expr l, Expr r), Env env) {
    if (vInt(int i1) := eval(l, env), vInt(int i2) := eval(r, env)) return vInt(i1 - i2);
    throw "Error: Tipos incompatibles en resta";
}

public Value eval(exprDiv(Expr l, Expr r), Env env) {
    if (vInt(int i1) := eval(l, env), vInt(int i2) := eval(r, env)) {
        if (i2 == 0) throw "Error: División por cero";
        return vInt(i1 / i2);
    }
    throw "Error: Tipos incompatibles en división";
}

public Value eval(exprMod(Expr l, Expr r), Env env) {
    if (vInt(int i1) := eval(l, env), vInt(int i2) := eval(r, env)) return vInt(i1 % i2);
    throw "Error: Tipos incompatibles en módulo";
}

public Value eval(expPoten(Expr l, Expr r), Env env) {
    if (vInt(int i1) := eval(l, env), vInt(int i2) := eval(r, env)) {
        int res = 1;
        for(_ <- [0..i2]) res *= i1;
        return vInt(res);
    }
    throw "Error: Tipos incompatibles en potencia";
}

public Value eval(exprGt(Expr l, Expr r), Env env) {
    if (vInt(int i1) := eval(l, env), vInt(int i2) := eval(r, env)) return vBool(i1 > i2);
    throw "Error de tipos en comparación \>";
}

public Value eval(exprLt(Expr l, Expr r), Env env) {
    if (vInt(int i1) := eval(l, env), vInt(int i2) := eval(r, env)) return vBool(i1 < i2);
    throw "Error: Tipos incompatibles en \<";
}

public Value eval(exprGte(Expr l, Expr r), Env env) {
    if (vInt(int i1) := eval(l, env), vInt(int i2) := eval(r, env)) return vBool(i1 >= i2);
    throw "Error: Tipos incompatibles en \>=";
}

public Value eval(exprLte(Expr l, Expr r), Env env) {
    if (vInt(int i1) := eval(l, env), vInt(int i2) := eval(r, env)) return vBool(i1 <= i2);
    throw "Error: Tipos incompatibles en \<= ";
}

public Value eval(exprNeq(Expr l, Expr r), Env env) = vBool(eval(l, env) != eval(r, env));

public Value eval(exprEq(Expr l, Expr r), Env env) = vBool(eval(l, env) == eval(r, env));

public Value eval(expAnd(Expr l, Expr r), Env env) {
    if (vBool(bool b1) := eval(l, env), vBool(bool b2) := eval(r, env)) return vBool(b1 && b2);
    throw "Error de tipos en AND ";
}

public Value eval(expOr(Expr l, Expr r), Env env) {
    if (vBool(bool b1) := eval(l, env), vBool(bool b2) := eval(r, env)) return vBool(b1 || b2);
    throw "Error: Tipos incompatibles en OR ";
}

public Value eval(expImp(Expr l, Expr r), Env env) {
    if (vBool(bool b1) := eval(l, env), vBool(bool b2) := eval(r, env)) return vBool(!b1 || b2);
    throw "Error: Tipos incompatibles en implicación: =\>";
}

public Value eval(expEquiv(Expr l, Expr r), Env env) {
    if (vBool(bool b1) := eval(l, env), vBool(bool b2) := eval(r, env)) return vBool(b1 == b2);
    throw "Error: Tipos incompatibles en equivalencia: ≡";
}

public Env fillEnv(Program p) {
    Env env = ();
    visit(p) {
        case vardef(list[Var] vars): {
            for (var(Type t, str id, _) <- vars) {
                // Inicializamos según el tipo
                if (t is intType) env[id] = vInt(0); 
                else if (t is boolType) env[id] = vBool(false);
                else env[id] = vInt(0);
            }
        }
    }
    return env;
}

public void runVeriLang(Program p) {
    Env env = fillEnv(p); // Cargamos las variables del archivo .vl
    
    // Simulamos que el sensor o el usuario le dio un valor a edad
    if ("edad" in env) env["edad"] = vInt(20); 
    if ("activo" in env) env["activo"] = vBool(true);
    
    if (program(str id, _, list[Component] components) := p) {
        println("========================================");
        println(" EJECUTANDO PROGRAMA: <id>");
        println("========================================\n");
        
        for (componentRule(ruledef(Rule r1, Rule r2)) <- components) {
            println("Regla detectada: <r1.identifier> -\> <r2.identifier>");
            
            // Evaluamos el lado izquierdo de la regla
            for (Expr e <- r1.exprns) {
                println("  - Valor en lado izquierdo: <eval(e, env)>");
            }
            
            // Evaluamos el lado derecho de la regla
            for (Expr e <- r2.exprns) {
                println("  - Valor en lado derecho: <eval(e, env)>");
            }
            println("----------------------------------------");
        }
        println("\n--- FIN DE LA EJECUCIÓN ---");
    }
}