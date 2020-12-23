using System;

namespace ConsoleApp
{
    class Program
    {
        static void Main(string[] args)
        {
            int[,] data = new int[5, 7];

            Console.WriteLine("Len " + data.Length);
            Console.WriteLine("Len(0) " + data.GetLength(0));
            Console.WriteLine("Len(1) " + data.GetLength(1));

            Console.ReadKey();
        }
    }
}
