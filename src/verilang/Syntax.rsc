module Syntax

import ParseTree;

layout Whitespace = [\t\n\r\ ]* !>> [\t\n\r\ ];

keyword Keywords = "defmodule" | "end" | "using" | "defspace" | "defoperator" 
                 | "defexpression" | "defrule" | "forall" | "exists" | "and" 
                 | "or" | "neg" | "in" | "defvar" | "defer" ;

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

syntax SpaceDef = spacedef: "defspace" Identifier ("\<" Identifier)? "end";

syntax VarDef = vardef: "defvar" {Var ","}+ "end";

syntax Var = var: Identifier ":" Identifier;

syntax OperatorDef = operatordef: "defoperator" Identifier ":" Dominio AttrItems? "end";

syntax Dominio = dominio: {Identifier "-\>"}+;

syntax ExpressionDef = expressiondef: "defexpression" QuantifierExp AttrItems? "end";

syntax QuantifierExp = quantifierexp: "(" Quantifier Identifier "in" Identifier "." Expr ")";

syntax Quantifier = forall:"forall" | exists:"exists";

syntax Expr 
    = exprUnary: UnOp op Expr expr
    | exprParen: "(" Expr expr ")"
    | exprQuant: QuantifierExp qexp
    | exprAtomic: AtomicExp aexp
    > left (expPoten: Expr left "**" Expr right)
    > left (
          exprMul: Expr left "*" Expr right
        | exprDiv: Expr left "/" Expr right
        | exprMod: Expr left "%" Expr right
    )
    > left (
          exprAdd: Expr left "+" Expr right
        | exprSub: Expr left "-" Expr right
    )
    > left (
          exprLt:  Expr left "\<" Expr right
        | exprGt:  Expr left "\>" Expr right
        | exprGte: Expr left "\>=" Expr right
        | exprLte: Expr left "\<=" Expr right
        | exprNeq: Expr left "\<\>" Expr right
        | exprEq:  Expr left "=" Expr right
    )
    > left expAnd: Expr left "and" Expr right
    > left expOr:  Expr left "or" Expr right
    > left (
          expArrow:  Expr left "-\>" Expr right
        | expEquiv:  Expr left "≡" Expr right
        | expImp:    Expr left "=\>" Expr right
        | expIn:     Expr left "in" Expr right
    ) ;

syntax AtomicExp 
    = atomicexp: Identifier
    | atomicexpsimple: Literal;

syntax RuleDef = ruledef: "defrule" "(" Rule ")" "-\>" "(" Rule ")" "end";

syntax Rule = rule: Identifier Expr*;

syntax AttrItems = atteritems: "[" AttrItem+ "]";

syntax AttrItem = attritem: Identifier (":" Expr)?;

syntax UnOp = neg: "neg";

syntax Literal 
    = intliteral: IntLiteral 
    | floatliteral: FloatLiteral 
    | charliteral: CharLiteral;