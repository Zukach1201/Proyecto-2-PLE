module Syntax

layout Whitespace = [\t\n\r\ ]* !>> [\t\n\r\ ];

keyword Keywords = "defmodule" | "end" | "using" | "defspace" | "defoperator" 
                 | "defexpression" | "defrule" | "forall" | "exists" | "and" 
                 | "or" | "neg" | "in" | "defvar";

lexical Identifier = Letter(Letter|Digit|"-")* !>> [a-zA-Z0-9\-] \ Keywords;
lexical Letter = [a-zA-Z];
lexical Digit = [0-9];
lexical IntLiteral = Digit+ !>> [0-9];
lexical FloatLiteral = Digit+ "." Digit+ !>> [0-9];
lexical CharLiteral = "\"" (Letter|Digit) "\"";

start syntax Program = program: "defmodule" Identifier ImportModule* Component* "end";

syntax ImportModule = importmodule: "using" Identifier;

syntax Component 
    = componentSpace: SpaceDef
    | componentVar: VarDef
    | componentOp: OperatorDef
    | componentExp: ExpressionDef
    | componentRule: RuleDef;

syntax SpaceDef = spaceDef: "defspace" Identifier ("\<" Identifier)? "end";

syntax VarDef = vardef: "defvar" Var+ "end";

syntax Var = var: Identifier ":" Identifier ","?;

syntax OperatorDef = operatorDef: "defoperator" Identifier ":" Dominio AttrItems? "end";

syntax Dominio = dominio: Identifier {"-\>" Identifier}+;

syntax ExpressionDef = expressionDef: "defexpression" QuantifierExp AttrItems? "end";

syntax QuantifierExp = quantifierexp: "(" Quantifier Identifier "in" Identifier "." Expr ")";

syntax Quantifier = forall:"forall" | exists:"exists";

syntax Expr 
    = exprUnary: UnOp Expr
    | exprParen: "(" Expr ")"
    | exprQuant: QuantifierExp
    | exprAtomic: AtomicExp
    > left exprBin: Expr BinOp Expr;

syntax AtomicExp 
    = atomicexp: Identifier
    | atomicexpsimple: Literal;

syntax RuleDef = ruledef: "defrule" "(" Rule ")" "-\>" "(" Rule ")" "end";

syntax Rule = rule: Identifier Expr*;

syntax AttrItems = atteritems: "[" AttrItem+ "]";

syntax AttrItem = attrItem: Identifier (":" Expr)?;

syntax BinOp 
    = add: "+" | sub: "-" | mul: "*" | div: "/" | pow: "**" | mo: "%"
    | lt: "\<" | gt: "\>" | gte: "\>=" | lte: "\<=" | nrq: "\<\>" | eq: "="
    | and: "and" | or: "or" | arrow: "-\>" | equiv: "≡" | imp: "=\>" | i: "in";

syntax UnOp = neg: "neg";

syntax Literal 
    = intliteral: IntLiteral 
    | floatliteral: FloatLiteral 
    | charliteral: CharLiteral;