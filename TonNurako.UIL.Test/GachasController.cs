using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TonNurako.UIL.Test {
    public abstract class GachasController {
        public static string DataDir =>
            Path.GetFullPath(
                Path.Combine(
                    Path.GetDirectoryName(new Uri(typeof(GachasController).Assembly.CodeBase).LocalPath), "../../motif-code/tests/uil"));

        public string Gacha(string fn) {
            return Path.Combine(DataDir, fn);
        }
    }
}

