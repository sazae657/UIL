using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xunit;

namespace TonNurako.UIL.Test
{
    public class Class1 : GachasController {

        static string[] BlackList = { "Case.uil", "GSyntax2.uil", "validator.uil", "xlistError.uil", "U.uil" };

        public static IEnumerable<object[]> GetSource() {
            foreach (var s in System.IO.Directory.GetFiles(DataDir, "*.uil", System.IO.SearchOption.AllDirectories)) {
                bool boo = false;
                foreach (var b in BlackList) {
                    if (s.EndsWith(b)) {
                        boo = true;
                        break;
                    }
                }
                if (boo) {
                    continue;
                }
                yield return new object[] { s };
            }
        }
        [Theory, MemberData(nameof(GetSource))]
        void Run(string fileName) {
            Console.WriteLine($"==> {fileName} ==");
            var h = new Hierarchy();
            h.Open(fileName);
        }

    }
}
