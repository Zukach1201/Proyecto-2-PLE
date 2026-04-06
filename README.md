# 🚀 VeriLang - Rascal DSL Implementation

**Universidad de los Andes | ISIS-2111 PLE** **Proyecto 2 - Definición de Sintaxis y AST**

## 👥 Autores
* Sara Milena Poveda
* Nicolás Ascencio Marroquin

## 📝 Descripción del Proyecto
Este repositorio contiene la implementación en **Rascal MPL** de **VeriLang**, un Lenguaje de Dominio Específico (DSL) diseñado en la primera fase del curso. En esta segunda entrega, el proyecto abarca:
1.  **Reglas de Sintaxis (`Syntax.rsc`):** Definición robusta del lenguaje, resolviendo ambigüedades, ciclos infinitos y fragmentaciones presentes en el diseño original.
2.  **Árbol de Sintaxis Abstracta (`AST.rsc`):** Estructura de datos fuertemente tipada que refleja fielmente la sintaxis concreta, lista para la fase de implosión y análisis semántico.
3.  **Integración con el IDE (`Plugin.rsc`):** Soporte LSP para habilitar el coloreado de sintaxis (Syntax Highlighting) directamente en Visual Studio Code.

## 🛠️ Cómo ejecutar y probar el lenguaje

Para evaluar este proyecto y ver el coloreado de sintaxis en acción, siga estos pasos:

1. Clone o descargue este repositorio e impórtelo en Visual Studio Code asegurándose de que la extensión de **Rascal MPL** esté activa.
2. Navegue al archivo `src/main/rascal/verilang/Plugin.rsc`.
3. Haga clic en el botón **"Run in new Rascal terminal"** (ubicado justo encima de la función `void main()`).
4. Espere a que la terminal muestre el mensaje: *"VeriLang ha sido registrado con éxito."*
5. Abra cualquiera de los archivos de prueba ubicados en la carpeta `instances/` (por ejemplo, `test1.vl`). Podrá observar el resaltado de sintaxis de los módulos, espacios, reglas y cuantificadores.

## 📂 Estructura del Código

* `src/main/rascal/verilang/Syntax.rsc`: Define la gramática (lexical y syntax) y resuelve las ambigüedades estructurales mediante operadores de precedencia y jerarquías claras.
* `src/main/rascal/verilang/AST.rsc`: Define los tipos de datos (data) que representan el Árbol de Sintaxis Abstracta.
* `src/main/rascal/verilang/Plugin.rsc`: Archivo de configuración que lee el `RASCAL.MF` de forma dinámica y registra el parser en el IDE.
* `instances/*.vl`: Archivos de código escritos en VeriLang para probar la robustez del parser.
* `documentacion.pdf`: Documento detallado que explica y justifica las correcciones realizadas a la gramática original del Proyecto 1 para que funcionara correctamente bajo el motor de Rascal.