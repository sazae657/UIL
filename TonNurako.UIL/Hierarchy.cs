using Antlr4.Runtime;
using Antlr4.Runtime.Tree;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TonNurako.UIL.Gen;

namespace TonNurako.UIL
{
    class ErrorListener : IAntlrErrorListener<IToken> {
        public List<string> Error { get; }
        string FileName;
        public ErrorListener(string f) {
            Error = new List<string>();
            FileName = Path.GetFileName(f);
        }

        public void SyntaxError(IRecognizer recognizer, IToken offendingSymbol, int line, int charPositionInLine, string msg, RecognitionException e) {
            Error.Add(
                $"{FileName} : {line} 行目 {charPositionInLine} 文字 {offendingSymbol.Text} 辺り構文エラーがあるくさい");
        }
    }

    public class Hierarchy {
        public void Open(string fileName) {
            using (var file =
                new System.IO.FileStream(fileName, System.IO.FileMode.Open)) {
                Open(file, fileName);
            }
        }

        public void Open(Stream stream, string fileName) {
            var inputStream = new AntlrInputStream(stream);
            var lexer = new UILLexer(inputStream);
            var commonTokenStream = new CommonTokenStream(lexer);
            var parser = new UILParser(commonTokenStream);
            parser.BuildParseTree = true;
            var e = new ErrorListener(fileName);
            parser.AddErrorListener(e);
            IParseTree tree = parser.unit();

            if (e.Error.Count != 0) {
                throw new Exception(string.Join("\n", e.Error));
            }

        }
    }
}
