module AST

data Program = program(str identifier, list[ImportModule] imports, list[Component] components);

data ImportModule = importmodule(str identifier);

data Component 
    = componentSpace(SpaceDef space)
    | componentVar(VarDef vardef)
    | componentOp(OperatorDef op)
    | componentExp(ExpressionDef expdef)
    | componentRule(RuleDef ruledef);

data SpaceDef = spacedef(str identifier, list[str] parent); //parent puede ser vacia.

data VarDef = vardef(list[Var] var);

data Var = var(str identifier, str identifier2);

data OperatorDef = operatordef(str identifier, Dominio dom, list[AttrItems] atteritems); //attrItems puede ser vacia.

data Dominio = dominio(list[str] identifiers);

data ExpressionDef = expressiondef(QuantifierExp cuant, list[AttrItems] atteritems); //attrItems puede ser vacia también.

data QuantifierExp = quantifierexp(Quantifier quantifier, str identifier, str identifier2, Expr exp);

data Quantifier = forall() | exists();

data Expr 
    = exprBin(Expr left, BinOp op, Expr right)
    | exprUnary(UnOp op, Expr expr)
    | exprParen(Expr expr)
    | exprQuant(QuantifierExp qexp)
    | exprAtomic(AtomicExp aexp);

data AtomicExp 
    = atomicexp(str identifier)
    | atomicexpsimple(Literal lit);

data RuleDef = ruledef(Rule rule, Rule rule2);

data Rule = rule(str identifier, list[Expr] exprns);

data AttrItems = atteritems(list[AttrItem] items);

data AttrItem = attritem(str identifier, list[Expr] expr);

data BinOp 
    = add() | sub() | mul() | div() | pow() | mo() | lt() | gt() | gte() | lte() | nrq() | eq() | and() | or() | arrow() | equiv() | imp() | i();

data UnOp = neg();

data Literal 
    = intliteral(str digits)
    | floatliteral(str digits)
    | charliteral(str char);