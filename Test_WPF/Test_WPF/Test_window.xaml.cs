using System;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;
using System.Windows.Shapes;

namespace Test_WPF
{
    /// <summary>
    /// Логика взаимодействия для Test_window.xaml
    /// </summary>
    public partial class Test_window : Window
    {
        int loopCounter;
        private System.Windows.Threading.DispatcherTimer timer;
        Random rand = new Random();
        Ellipse ellipse = null;

        public Test_window()
        {
            InitializeComponent();

            test();
            //test2();
        }

        public void test2()
        {
            //Initialize the timer class
            timer = new System.Windows.Threading.DispatcherTimer();
            timer.Interval = TimeSpan.FromSeconds(1); //Set the interval period here.
            timer.Tick += timer1_Tick;

            loopCounter = 100;
            timer.Start();
        }

        private void timer1_Tick(object sender, EventArgs e)
        {
            Console.WriteLine("tick " + loopCounter);

            //Remove the previous ellipse from the paint canvas.
            Can1.Children.Remove(ellipse);

            if (--loopCounter == 0)
                timer.Stop();

            //Add the ellipse to the canvas
            ellipse = CreateAnEllipse(50, 50);
            Can1.Children.Add(ellipse);

            Canvas.SetLeft(ellipse, rand.Next(0, 310));
            Canvas.SetTop(ellipse,  rand.Next(0, 500));
        }

        // Customize your ellipse in this method
        public Ellipse CreateAnEllipse(int height, int width)
        {
            SolidColorBrush fillBrush = new SolidColorBrush() { Color = Colors.Red };
            SolidColorBrush borderBrush = new SolidColorBrush() { Color = Colors.Black };

            return new Ellipse()
            {
                Height = height,
                Width = width,
                StrokeThickness = 1,
                Stroke = borderBrush,
                Fill = fillBrush
            };
        }

        public void test()
        {
            // Create a red Ellipse.
            Ellipse myEllipse = new Ellipse();

            // Create a SolidColorBrush with a red color to fill the 
            // Ellipse with.
            SolidColorBrush mySolidColorBrush = new SolidColorBrush();

            // Describes the brush's color using RGB values. 
            // Each value has a range of 0-255.
            mySolidColorBrush.Color = Color.FromArgb(255, 255, 0, 0);
            myEllipse.Fill = mySolidColorBrush;
            myEllipse.StrokeThickness = 2;
            myEllipse.Stroke = Brushes.Black;

            // Set the width and height of the Ellipse.
            myEllipse.Width = 200;
            myEllipse.Height = 200;

            // Add the Ellipse to the StackPanel.
            //myStackPanel.Children.Add(myEllipse);
            Can1.Children.Add(myEllipse);

            Canvas.SetLeft(myEllipse, 0);
            Canvas.SetTop(myEllipse, 0);
        }
    }
}
