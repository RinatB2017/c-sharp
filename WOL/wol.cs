using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Sockets;

namespace Wol {
    class Program {
        static void Main (string[] args) {
            using (UdpClient udpClient = new UdpClient ()) {
                Console.WriteLine ("Enter mac address");
                byte[] mac = StrToMac (Console.ReadLine ());
                udpClient.Send (mac, mac.Length, new IPEndPoint (IPAddress.Broadcast, 9));
            }
        }

        static byte[] StrToMac (string s) {
            List<byte> arr = new List<byte> (102);

            string[] macs = s.Split (' ', ':', '-');

            for (int i = 0; i < 6; i++)
                arr.Add (0xff);

            for (int j = 0; j < 16; j++)
                for (int i = 0; i < 6; i++)
                    arr.Add (Convert.ToByte (macs[i], 16));

            return arr.ToArray ();
        }
    }
}