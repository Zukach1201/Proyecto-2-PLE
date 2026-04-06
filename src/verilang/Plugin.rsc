module Plugin

import util::LanguageServer;
import util::IDEServices;
import util::PathConfig;
import ParseTree;
import Syntax;

Tree verilangParser(str input, loc origin) {
    return parse(#start[Program], input, origin);
}

set[LanguageService] verilangContributions() = {
    parsing(verilangParser)
};

void main() {
    registerLanguage(
        language(
            pathConfig(srcs=[|project://proyecto2/src/verilang|]),
            "VeriLang",
            {"vl"},
            "Plugin",
            "verilangContributions"
        )
    );
}