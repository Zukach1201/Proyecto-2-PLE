module Syntax

import ParseTree;

layout Whitespace = [\t\n\r\ ]* !>> [\t\n\r\ ];

keyword Keywords = "defmodule" | "end" | "using" | "defspace" | "defoperator" 
                 | "defexpression" | "defrule" | "forall" | "exists" | "and" 
                 | "or" | "neg" | "in" | "defvar" | "defer"
                 | "Int" | "Float" | "Char" | "Bool" | "String"
                 | "true" | "false" | "defdata";

lexical Identifier = Letter(Letter|Digit|"-")* !>> [a-zA-Z0-9\-] \ Keywords;
lexical Letter = [a-zA-Z];
lexical Digit = [0-9];
lexical IntLiteral = Digit+ !>> [0-9];
lexical FloatLiteral = Digit+ "." Digit+ !>> [0-9];

lexical StringLiteral = "\"" ![\"]* "\"";
lexical CharLiteral = "\'" ![\'] "\'";
lexical BoolLiteral = "true" | "false";

start syntax Program = program: "defmodule" Identifier identifier ImportModule* imports Component* components "end";

syntax ImportModule = importmodule: "using" Identifier identifier;
syntax Component 
    = componentSpace: SpaceDef space
    | componentVar: VarDef vardef
    | componentOp: OperatorDef op
    | componentExp: ExpressionDef expdef
    | componentRule: RuleDef ruledef
    | componentData: DataDef datadef;

syntax SpaceDef = spaceDef: "defspace" Identifier identifier ("\<" Identifier parent)? "end";

syntax VarDef = vardef: "defvar" {Var ","}+ "end";

syntax DataDef = datadef: "defdata" Type typ Identifier identifier "=" "{" {Identifier ","}* elements "}" "end";

syntax Var = var: Type typ Identifier identifier ":" Identifier identifier2;

syntax OperatorDef = operatorDef: "defoperator" Type returnType Identifier identifier ":" Dominio dom AttrItems? atteritems "end";

syntax Dominio = dominio: {Identifier "-\>"}+ identifiers;

syntax ExpressionDef = expressiondef: "defexpression" Type typ QuantifierExp cuant AttrItems? atteritems "end";

syntax QuantifierExp = quantifierexp: "(" Quantifier quantifier Identifier identifier "in" Identifier identifier2 "." Expr exp ")";

syntax Quantifier = forall:"forall" | exists:"exists";

syntax Type
    = intType: "Int"
    | floatType: "Float"
    | charType: "Char"
    | boolType: "Bool"
    | stringType: "String";

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

syntax AttrItem = attrItem: Identifier identifier (":" Expr expr)?;

syntax UnOp = neg: "neg";

syntax Literal 
    = intliteral: IntLiteral digits
    | floatliteral: FloatLiteral digits
    | charliteral: CharLiteral charValue
    | stringliteral: StringLiteral stringValue
    | boolliteral: BoolLiteral boolValue;

