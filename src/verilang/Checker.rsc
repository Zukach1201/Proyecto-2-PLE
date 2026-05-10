module Checker

import AST;
import Types;
import IO;

alias TypeEnv = map[str, VType];

public list[str] checkProgram(program(str identifier, list[ImportModule] imports, list[Component] components)) {
    set[str] spaces = collectSpaces(components);
    TypeEnv vars = ();
    list[str] errors = [];

    for (Component c <- components) {
        <vars, errors> = checkComponent(c, spaces, vars, errors);
    }

    return errors;
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