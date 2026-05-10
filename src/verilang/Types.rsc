module Types

import AST;

data VType
    = tInt()
    | tFloat()
    | tChar()
    | tBool()
    | tString()
    | tSpace(str name)
    | tData(VType elementType)
    | tUnknown();

public VType toVType(intType()) = tInt();
public VType toVType(floatType()) = tFloat();
public VType toVType(charType()) = tChar();
public VType toVType(boolType()) = tBool();
public VType toVType(stringType()) = tString();

public bool isNumeric(tInt()) = true;
public bool isNumeric(tFloat()) = true;
public bool isNumeric(VType t) = false;