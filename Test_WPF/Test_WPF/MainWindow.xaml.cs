using System;
using System.Collections.Generic;
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

namespace Test_WPF
{
    /// <summary>
    /// Логика взаимодействия для MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            Button btn = sender as Button;

            MessageBoxResult result = MessageBox.Show(
                "Текст",
                "Выберите вариант:",
                MessageBoxButton.YesNo,
                MessageBoxImage.Information);
            if(result == MessageBoxResult.Yes)
            {
                //MessageBox.Show("Да", "Информация", MessageBoxButton.OK, MessageBoxImage.Information);
                btn.Background = Brushes.Red;
            }
            else
            {
                //MessageBox.Show("Нет", "Информация", MessageBoxButton.OK, MessageBoxImage.Information);
                btn.Background = Brushes.Green;
            }
        }
    }
}
