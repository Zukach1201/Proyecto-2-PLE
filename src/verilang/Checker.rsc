module Checker

import AST;
import Types;
import IO;

alias TypeEnv = map[str, VType];

public list[str] checkProgram(Program p) { 
    if (program(str identifier, list[ImportModule] imports, list[Component] components) := p) {
        set[str] spaces = collectSpaces(components);
        TypeEnv vars = ();
        list[str] errors = [];

        for (Component c <- components) {
            <vars, errors> = checkComponent(c, spaces, vars, errors);
        }

        return errors;
    }
    return ["Error: El AST no tiene el formato esperado."];
}

public set[str] collectSpaces(list[Component] components) {
    set[str] spaces = {};

    for (Component c <- components) {
        spaces += collectSpace(c);
    }

    return spaces;
}

public set[str] collectSpace(componentSpace(spaceDef(str identifier, list[str] parent))) {
    return {identifier};
}

public set[str] collectSpace(Component c) {
    return {};
}

public tuple[TypeEnv, list[str]] checkComponent(
    componentSpace(spaceDef(str identifier, list[str] parent)),
    set[str] spaces,
    TypeEnv vars,
    list[str] errors
) {
    for (str p <- parent) {
        if (!(p in spaces)) {
            errors += ["Space <identifier> extends undefined space <p>."];
        }
    }

    return <vars, errors>;
}

public tuple[TypeEnv, list[str]] checkComponent(
    componentVar(VarDef vardef),
    set[str] spaces,
    TypeEnv vars,
    list[str] errors
) {
    return checkVarDef(vardef, spaces, vars, errors);
}

public tuple[TypeEnv, list[str]] checkComponent(
    componentOp(OperatorDef op),
    set[str] spaces,
    TypeEnv vars,
    list[str] errors
) {
    return checkOperator(op, spaces, vars, errors);
}

public tuple[TypeEnv, list[str]] checkComponent(
    componentExp(ExpressionDef expdef),
    set[str] spaces,
    TypeEnv vars,
    list[str] errors
) {
    return checkExpressionDef(expdef, spaces, vars, errors);
}

public tuple[TypeEnv, list[str]] checkComponent(
    componentRule(RuleDef ruledef),
    set[str] spaces,
    TypeEnv vars,
    list[str] errors
) {
    return checkRuleDef(ruledef, vars, errors);
}

public tuple[TypeEnv, list[str]] checkComponent(
    componentData(DataDef datadef),
    set[str] spaces,
    TypeEnv vars,
    list[str] errors
) {
    return checkDataDef(datadef, vars, errors);
}

public tuple[TypeEnv, list[str]] checkComponent(
    Component c,
    set[str] spaces,
    TypeEnv vars,
    list[str] errors
) {
    return <vars, errors>;
}

public tuple[TypeEnv, list[str]] checkVarDef(
    vardef(list[Var] varsList),
    set[str] spaces,
    TypeEnv vars,
    list[str] errors
) {
    for (Var v <- varsList) {
        <vars, errors> = checkVar(v, spaces, vars, errors);
    }

    return <vars, errors>;
}

public tuple[TypeEnv, list[str]] checkVar(
    var(Type typ, str identifier, str identifier2),
    set[str] spaces,
    TypeEnv vars,
    list[str] errors
) {
    if (identifier in vars) {
        errors += ["Variable <identifier> is already defined."];
    }

    if (!(identifier2 in spaces)) {
        errors += ["Variable <identifier> uses undefined space <identifier2>."];
    }

    vars[identifier] = toVType(typ);

    return <vars, errors>;
}


public tuple[TypeEnv, list[str]] checkOperator(
    operatorDef(Type returnType, str identifier, dominio(list[str] identifiers), list[AttrItems] atteritems),
    set[str] spaces,
    TypeEnv vars,
    list[str] errors
) {
    for (str d <- identifiers) {
        if (!(d in spaces)) {
            errors += ["Operator <identifier> uses undefined domain <d>."];
        }
    }

    return <vars, errors>;
}

public tuple[TypeEnv, list[str]] checkExpressionDef(
    expressiondef(Type typ, QuantifierExp cuant, list[AttrItems] atteritems),
    set[str] spaces,
    TypeEnv vars,
    list[str] errors
) {
    VType expected = toVType(typ);
    VType actual = typeOfQuantifier(cuant, spaces, vars);

    if (expected != actual) {
        errors += ["Expression type error. Expected <expected>, got <actual>."];
    }

    return <vars, errors>;
}

public tuple[TypeEnv, list[str]] checkDataDef(
    datadef(Type typ, str identifier, list[str] elements), 
    TypeEnv vars,
    list[str] errors
) {
    VType expectedType = toVType(typ); // El tipo que el usuario definió para el defdata
    
    for (str e <- elements) {
        if (!(e in vars)) {
            errors += ["Data Error: Element <e> in data structure <identifier> does not exist."];
        } else if (vars[e] != expectedType) {
            errors += ["Type Error: Element <e> is <vars[e]>, but data structure <identifier> expects <expectedType>."];
        }
    }
    return <vars, errors>;
}

public VType typeOfQuantifier(
    quantifierexp(Quantifier quantifier, str identifier, str identifier2, Expr exp),
    set[str] spaces,
    TypeEnv vars
) {
    if (!(identifier2 in spaces)) {
        return tUnknown();
    }

    TypeEnv localVars = vars;
    localVars[identifier] = tSpace(identifier2);

    VType bodyType = typeOf(exp, localVars);

    if (bodyType == tBool()) {
        return tBool();
    }

    return tUnknown();
}

public VType typeOf(exprAtomic(atomicexp(str id)), TypeEnv env) = env[id] ? tUnknown();

public VType typeOf(exprAtomic(atomicexpsimple(intliteral(_))), TypeEnv env) = tInt();
public VType typeOf(exprAtomic(atomicexpsimple(boolliteral(_))), TypeEnv env) = tBool();

public VType typeOf(exprAdd(Expr l, Expr r), TypeEnv env) = checkBinary(l, r, tInt(), tInt(), env);
public VType typeOf(exprSub(Expr l, Expr r), TypeEnv env) = checkBinary(l, r, tInt(), tInt(), env);
public VType typeOf(exprMul(Expr l, Expr r), TypeEnv env) = checkBinary(l, r, tInt(), tInt(), env);
public VType typeOf(exprDiv(Expr l, Expr r), TypeEnv env) = checkBinary(l, r, tInt(), tInt(), env);
public VType typeOf(exprMod(Expr l, Expr r), TypeEnv env) = checkBinary(l, r, tInt(), tInt(), env);
public VType typeOf(expPoten(Expr l, Expr r), TypeEnv env) = checkBinary(l, r, tInt(), tInt(), env);

public VType typeOf(exprGt(Expr l, Expr r), TypeEnv env) = checkBinary(l, r, tInt(), tBool(), env);
public VType typeOf(exprLt(Expr l, Expr r), TypeEnv env) = checkBinary(l, r, tInt(), tBool(), env);
public VType typeOf(exprGte(Expr l, Expr r), TypeEnv env) = checkBinary(l, r, tInt(), tBool(), env);
public VType typeOf(exprLte(Expr l, Expr r), TypeEnv env) = checkBinary(l, r, tInt(), tBool(), env);
public VType typeOf(exprEq(Expr l, Expr r), TypeEnv env) = tBool(); // Simplificado
public VType typeOf(exprNeq(Expr l, Expr r), TypeEnv env) = tBool();

public VType typeOf(expAnd(Expr l, Expr r), TypeEnv env) = checkBinary(l, r, tBool(), tBool(), env);
public VType typeOf(expOr(Expr l, Expr r), TypeEnv env) = checkBinary(l, r, tBool(), tBool(), env);
public VType typeOf(expArrow(Expr l, Expr r), TypeEnv env) = checkBinary(l, r, tBool(), tBool(), env);
public VType typeOf(expImp(Expr l, Expr r), TypeEnv env) = checkBinary(l, r, tBool(), tBool(), env);
public VType typeOf(expEquiv(Expr l, Expr r), TypeEnv env) = checkBinary(l, r, tBool(), tBool(), env);

public VType typeOf(exprUnary(neg(), Expr e), TypeEnv env) = (typeOf(e, env) == tBool()) ? tBool() : tUnknown();
public VType typeOf(exprParen(Expr e), TypeEnv env) = typeOf(e, env);

public VType checkBinary(Expr l, Expr r, VType expectedIn, VType resultOut, TypeEnv env) {
    if (typeOf(l, env) == expectedIn && typeOf(r, env) == expectedIn) {
        return resultOut;
    }
    return tUnknown(); // O un tError personalizado
}

public tuple[TypeEnv, list[str]] checkRuleDef(
    ruledef(Rule rule1, Rule rule2), // Cambiado r1/r2 por rule1/rule2 para evitar conflictos
    TypeEnv vars,
    list[str] errors
) {
    for (Expr e <- rule1.exprns) {
        if (typeOf(e, vars) != tBool()) {
            errors += ["Rule error in <rule1.identifier>: Expression must be Boolean."];
        }
    }
    
    for (Expr e <- rule2.exprns) {
        if (typeOf(e, vars) != tBool()) {
            errors += ["Rule error in <rule2.identifier>: Expression must be Boolean."];
        }
    }
    
    return <vars, errors>;
}