using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using RDotNet;
using System.IO;
using System.Collections.ObjectModel;

namespace WineQualityPrediction
{
    class WineQualityPredictor: IDisposable
    {
        private string path;
        private REngine engine;

        public WineQualityPredictor(string pathToDate)
        {
            SetupPath();
            path = pathToDate;
            engine = REngine.GetInstance();
            engine.Initialize();
        }

        public ObservableCollection<Feature> GetFeatures()
        {
            engine.Evaluate(string.Format("w.p <- read.csv('{0}{1}{2}')", path, "//", "winequality-white.csv"));
            engine.Evaluate(string.Format("source('{0}{1}{2}')", path, "//", "DataProcessing.R"));
            var length = engine.Evaluate("length(w.p)").AsInteger()[0] - 1;
            var names = engine.Evaluate(string.Format("colnames(w.p[1:{0}])",length)).AsCharacter().ToArray();
            var features = new ObservableCollection<Feature>();
            foreach(var name in names)
            {
                var min = engine.Evaluate(string.Format("min(w.p${0})", name)).AsNumeric().ToArray()[0];
                var max = engine.Evaluate(string.Format("max(w.p${0})", name)).AsNumeric().ToArray()[0];
                features.Add(new Feature(name, max, min));
            }
            return features;
        }

        public string Predict(params string[] parameters)
        {
            var wineParams = new StringBuilder("data.frame(");
            foreach (var param in parameters)
                wineParams.Append(param + ",");
            wineParams.Remove(wineParams.Length - 1, 1);
            wineParams.Append(")");
            engine.Evaluate(string.Format("wine.parameters <- {0}", wineParams.ToString()));
            engine.Evaluate("names(wine.parameters) <- colnames(w.p[1:length(w.p)-1])");
            engine.Evaluate("predictions <- predict(fit.rf, wine.parameters)");
            return engine.Evaluate("as.character(predictions)").AsCharacter().ToArray()[0];
        }

        public static void SetupPath()
        {
            var oldPath = Environment.GetEnvironmentVariable("PATH");
            var rPath1 = @"C:\Program Files\Microsoft\R Client\R_SERVER\bin\x64";
            var rPath2 = @"C:\Program Files\Microsoft\R Client\R_SERVER\library\caret\R";
            if (!Directory.Exists(rPath1))
                throw new DirectoryNotFoundException(string.Format(" R.dll not found in : {0}", rPath1));
            var newPath = string.Format("{0}{1}{2}", rPath1, Path.PathSeparator, oldPath);
            newPath = string.Format("{0}{1}{2}", rPath2, Path.PathSeparator, newPath);
            Environment.SetEnvironmentVariable("PATH", newPath);
        }

        public void Dispose() => engine.Dispose();
    }
}