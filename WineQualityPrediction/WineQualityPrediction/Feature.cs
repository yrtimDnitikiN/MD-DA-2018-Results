using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;
using System.Windows;

namespace WineQualityPrediction
{
    class Feature: INotifyPropertyChanged
    {
        private double val;

        public string Name { get; set; }
        public double Min { get; set; }
        public double Max { get; set; }

        public double Value
        {
            get { return val; }
            set
            {
                if (value > Max || value < Min)
                    throw new ArgumentException();
                val = value;
                OnPropertyChanged("Value");
            }
        }

        public Feature(string name, double max, double min)
        {
            Name = name;
            Min = min;
            Max = max;
            Reset();
        }

        public void Reset()
        {
            Value = (Min + Max) / 2;
        }

        public event PropertyChangedEventHandler PropertyChanged;
        public void OnPropertyChanged([CallerMemberName]string prop = "")
        {
            if (PropertyChanged != null)
                PropertyChanged(this, new PropertyChangedEventArgs(prop));
        }
    }
}
