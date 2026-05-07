module AST

data Program = program(str identifier, list[ImportModule] imports, list[Component] components);

data ImportModule = importmodule(str identifier);

data Component 
    = componentSpace(SpaceDef space)
    | componentVar(VarDef vardef)
    | componentOp(OperatorDef op)
    | componentExp(ExpressionDef expdef)
    | componentRule(RuleDef ruledef);

data SpaceDef = spaceDef(str identifier, list[str] parent); //parent puede ser vacia.

data VarDef = vardef(list[Var] vars);

data Var = var(str identifier, str identifier2);

data OperatorDef = operatorDef(str identifier, Dominio dom, list[AttrItems] atteritems); //attrItems puede ser vacia.

data Dominio = dominio(list[str] identifiers);

data ExpressionDef = expressiondef(QuantifierExp cuant, list[AttrItems] atteritems); //attrItems puede ser vacia también.

data QuantifierExp = quantifierexp(Quantifier quantifier, str identifier, str identifier2, Expr exp);

data Quantifier = forall() | exists();

data Expr 
    = exprUnary(UnOp Unop, Expr expr)
    | exprParen(Expr expr)
    | exprQuant(QuantifierExp qexp)
    | exprAtomic(AtomicExp aexp)
    | expPoten(Expr left, Expr right)
    | exprMul(Expr left, Expr right)
    | exprDiv(Expr left, Expr right)
    | exprMod(Expr left, Expr right)
    | exprAdd(Expr left, Expr right)
    | exprSub(Expr left, Expr right)
    | exprLt(Expr left, Expr right)
    | exprGt(Expr left, Expr right)
    | exprGte(Expr left, Expr right)
    | exprLte(Expr left, Expr right)
    | exprNeq(Expr left, Expr right)
    | exprEq(Expr left, Expr right)
    | expAnd(Expr left, Expr right)
    | expOr(Expr left, Expr right)
    | expArrow(Expr left, Expr right)
    | expEquiv(Expr left, Expr right)
    | expImp(Expr left, Expr right)
    | expIn(Expr left, Expr right);

data AtomicExp 
    = atomicexp(str identifier)
    | atomicexpsimple(Literal lit);

data RuleDef = ruledef(Rule rule, Rule rule2);

data Rule = rule(str identifier, list[Expr] exprns);

data AttrItems = atteritems(list[AttrItem] items);

data AttrItem = attrItem(str identifier, list[Expr] expr);

data UnOp = neg();

data Literal 
    = intliteral(str digits)
    | floatliteral(str digits)
    | charliteral(str char);