using System;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;

namespace Test_WPF
{
    /// <summary>
    /// Логика взаимодействия для MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        TextBox te;
        Button btn2;
        ProgressBar progress;

        public MainWindow()
        {
            InitializeComponent();

            Init_gl();
        }

        private void Init_gl()
        {
            te = (TextBox)this.FindName("tb_text");
            te.Clear();

            btn2 = (Button)this.FindName("btn_main");
            btn2.Content = "TEST";

            progress = (ProgressBar)this.FindName("pb_test");
            progress.Value = 33;
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
                Console.WriteLine("Красный цвет");
            }
            else
            {
                //MessageBox.Show("Нет", "Информация", MessageBoxButton.OK, MessageBoxImage.Information);
                btn.Background = Brushes.Green;
                Console.WriteLine("Зеленый цвет");
            }
        }

        private void Button_Click_1(object sender, RoutedEventArgs e)
        {
            Test_window tw = new Test_window();
            tw.Show();
        }

        private void Button_Click_2(object sender, RoutedEventArgs e)
        {
            var n = 2;
            te.Text = "n=" + n;
        }

    }
}
