using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace WineQualityPrediction
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        ObservableCollection<Feature> features;
        WineQualityPredictor predictor;

        public MainWindow()
        {
            InitializeComponent();

            predictor = new WineQualityPredictor("..//..//Data");
            features = predictor.GetFeatures();
            featuresGrid.ItemsSource = features;
        }

        private void Predict_Click(object sender, RoutedEventArgs e)
        {
            var values = new List<string>();
            foreach (var feature in features)
                values.Add(feature.Value.ToString());
            quality.Content = predictor.Predict(values.ToArray());
        }

        private void Reset_Click(object sender, RoutedEventArgs e)
        {
            foreach(var feature in features)
                feature.Reset();
        }
    }
}
