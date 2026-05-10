module Parser

import Syntax;
import ParseTree;

public start[Program] parseVeriLang(loc archivo) = parse(#start[Program], archivo);