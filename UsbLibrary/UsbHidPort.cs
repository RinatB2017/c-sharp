using System;
using System.ComponentModel;
using System.Collections.Generic;
using System.Diagnostics;
using System.Text;
using System.Drawing;
using System.Windows.Forms;

namespace UsbLibrary
{
/// <summary>
    /// This class provides an usb component. This can be placed ont to your form.
    /// </summary>
    [ToolboxBitmap(typeof(UsbHidPort), "UsbHidBmp.bmp")]
    public partial class UsbHidPort : Component
    {
        private int product_id;
        private int vendor_id;
        private Guid device_class;
        private IntPtr usb_event_handle;
        private SpecifiedDevice specified_device;
        private IntPtr handle;
        private string device_product = null;

        //events
        /// <summary>
        /// This event will be triggered when the device you specified is pluged into your usb port on
        /// the computer. And it is completly enumerated by windows and ready for use.
        /// </summary>
        [Description("The event that occurs when a usb hid device with the specified vendor id and product id is found on the bus")]
        [Category("Embedded Event")]
        [DisplayName("OnSpecifiedDeviceArrived")]
        public event EventHandler               OnSpecifiedDeviceArrived;

        /// <summary>
        /// This event will be triggered when the device you specified is removed from your computer.
        /// </summary>
        [Description("The event that occurs when a usb hid device with the specified vendor id and product id is removed from the bus")]
        [Category("Embedded Event")]
        [DisplayName("OnSpecifiedDeviceRemoved")]
        public event EventHandler               OnSpecifiedDeviceRemoved;

        /// <summary>
        /// This event will be triggered when a device is pluged into your usb port on
        /// the computer. And it is completly enumerated by windows and ready for use.
        /// </summary>
        [Description("The event that occurs when a usb hid device is found on the bus")]
        [Category("Embedded Event")]
        [DisplayName("OnDeviceArrived")]
        public event EventHandler               OnDeviceArrived;

        /// <summary>
        /// This event will be triggered when a device is removed from your computer.
        /// </summary>
        [Description("The event that occurs when a usb hid device is removed from the bus")]
        [Category("Embedded Event")]
        [DisplayName("OnDeviceRemoved")]
        public event EventHandler               OnDeviceRemoved;

        /// <summary>
        /// This event will be triggered when data is recieved from the device specified by you.
        /// </summary>
        [Description("The event that occurs when data is recieved from the embedded system")]
        [Category("Embedded Event")]
        [DisplayName("OnDataRecieved")]
        public event DataRecievedEventHandler   OnDataRecieved;

        /// <summary>
        /// This event will be triggered when data is send to the device. 
        /// It will only occure when this action wass succesfull.
        /// </summary>
        [Description("The event that occurs when data is send from the host to the embedded system")]
        [Category("Embedded Event")]
        [DisplayName("OnDataSend")]
        public event EventHandler               OnDataSend;

        public UsbHidPort()
        {
            product_id = 0;
            vendor_id = 0;
            specified_device = null;
            device_product = null;
            device_class = Win32Usb.HIDGuid;

            InitializeComponent();
        }
        
        public UsbHidPort(IContainer container)
        {
            //initializing in initial state
            product_id = 0;
            vendor_id = 0;
            specified_device = null;
            device_product = null;
            device_class = Win32Usb.HIDGuid;

            container.Add(this);
            InitializeComponent();
        }

        [Description("The product id from the USB device you want to use")]
        [DefaultValue("(none)")]
        [Category("Embedded Details")]
        public int ProductId
        {
            get { return this.product_id; }
            set { this.product_id = value; }
        }

       [Description("The vendor id from the USB device you want to use")]
       [DefaultValue("(none)")]
       [Category("Embedded Details")]
        public int VendorId
        {
            get { return this.vendor_id; }
            set { this.vendor_id = value; }
        }

        [Description("The Device Class the USB device belongs to")]
        [DefaultValue("(none)")]
        [Category("Embedded Details")]
        public Guid DeviceClass
        {
            get { return device_class; }
        }

        [Description("The Device witch applies to the specifications you set")]
        [DefaultValue("(none)")]
        [Category("Embedded Details")]

        #region Base 
        public SpecifiedDevice SpecifiedDevice
        {
            get { return this.specified_device; }
        }

        /// <summary>
        /// Registers this application, so it will be notified for usb events.  
        /// </summary>
        /// <param name="Handle">a IntPtr, that is a handle to the application.</param>
        /// <example> This sample shows how to implement this method in your form.
        /// <code> 
        ///protected override void OnHandleCreated(EventArgs e)
        ///{
        ///    base.OnHandleCreated(e);
        ///    usb.RegisterHandle(Handle);
        ///}
        ///</code>
        ///</example>
        public void RegisterHandle(IntPtr Handle)
        {
            usb_event_handle = Win32Usb.RegisterForUsbEvents(Handle, device_class);
            this.handle = Handle;
            //Check if the device is already present.
            CheckDevicePresent();
        }

        /// <summary>
        /// Unregisters this application, so it won't be notified for usb events.  
        /// </summary>
        /// <returns>Returns if it was succesfull to unregister.</returns>
        public bool UnregisterHandle()
        {
            if (this.handle != null)
            {
                return Win32Usb.UnregisterForUsbEvents(this.handle);
            }
            
            return false;
        }

        /// <summary>
        /// This method will filter the messages that are passed for usb device change messages only. 
        /// And parse them and take the appropriate action 
        /// </summary>
        /// <param name="m">a ref to Messages, The messages that are thrown by windows to the application.</param>
        /// <example> This sample shows how to implement this method in your form.
        /// <code> 
        ///protected override void WndProc(ref Message m)
        ///{
        ///    usb.ParseMessages(ref m);
        ///    base.WndProc(ref m);	    // pass message on to base form
        ///}
        ///</code>
        ///</example>
        public void ParseMessages(ref Message m)
        {
            ParseMessages(m.Msg, m.WParam);
        }

        /// <summary>
        /// This method will filter the messages that are passed for usb device change messages only. 
        /// And parse them and take the appropriate action 
        /// </summary>
        /// <param name="m">a ref to Messages, The messages that are thrown by windows to the application.</param>
        /// <example> This sample shows how to implement this method in your form.
        /// <code> 
        ///protected override void WndProc(ref Message m)
        ///{
        ///    usb.ParseMessages(ref m);
        ///    base.WndProc(ref m);	    // pass message on to base form
        ///}
        ///</code>
        ///</example>
        public void ParseMessages(int Msg, IntPtr WParam)
        { 
            if (Msg == Win32Usb.WM_DEVICECHANGE)	// we got a device change message! A USB device was inserted or removed
            {
                switch (WParam.ToInt32())	// Check the W parameter to see if a device was inserted or removed
                {
                    case Win32Usb.DEVICE_ARRIVAL:	// inserted
                        if (OnDeviceArrived != null)
                        {
                            OnDeviceArrived(this, new EventArgs());
                            CheckDevicePresent();
                        }
                        // Если подключенна обработка Только спец.девайса (иначе, без null события OnDeviceArrived не будет событий OnSpecifiedDeviceArrived)
                        else if (OnSpecifiedDeviceArrived != null)
                        {
                            CheckDevicePresent();
                        }
                        break;
                    case Win32Usb.DEVICE_REMOVECOMPLETE:	// removed
                        if (OnDeviceRemoved != null)
                        {
                            OnDeviceRemoved(this, new EventArgs());
                            CheckDevicePresent();
                        }
                        // Если подключенна обработка Только спец.девайса (аналогично верхнему)
                        // Данный косяк был замечен в оригинальной библиотеке, на которой базируется эта :)
                        else if (OnSpecifiedDeviceRemoved != null)
                        {
                            CheckDevicePresent();
                        }
                        break;

                    default:
                        break;
                }
            }
        }

        /// <summary>
        /// Checks the devices that are present at the moment and checks if one of those
        /// is the device you defined by filling in the product id and vendor id.
        /// </summary>
        private void CheckDevicePresent()
        {
            try
            {
                //Mind if the specified device existed before.
                bool history = false;

                if(specified_device != null )
                {       
                    history = true;
                }

                specified_device = SpecifiedDevice.FindSpecifiedDevice(this.vendor_id, this.product_id, device_product);
                
                if (specified_device != null)	// нашлось?
                {
                    if (OnSpecifiedDeviceArrived != null)
                    {
                        this.OnSpecifiedDeviceArrived(this, new EventArgs());
                        if (OnDataRecieved != null) specified_device.DataRecieved += new DataRecievedEventHandler(OnDataRecieved);
                        if (OnDataSend != null) specified_device.DataSend += new DataSendEventHandler(OnDataSend);
                    }
                }
                else
                {
                    if (OnSpecifiedDeviceRemoved != null && history)
                    {
                        this.OnSpecifiedDeviceRemoved(this, new EventArgs());
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.ToString());
            }
        }

        private void DataRecieved(object sender, DataRecievedEventArgs args)
        {
            if(this.OnDataRecieved != null)
            {
                this.OnDataRecieved(sender, args);
            }
        }

        private void DataSend(object sender, DataSendEventArgs args)
        {
            if (this.OnDataSend != null)
            {
                this.OnDataSend(sender, args);
            }
        }
        #endregion 

        #region Device Connect\Dicsconnect\Info
        /// <summary>
        /// Проверяем (мнимую) готовность устройства к работе.
        /// </summary>
        /// <returns>Возвращает True, если устройство готово,иначе False</returns>
        public bool Ready()
        {
            if (SpecifiedDevice != null)
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        /// <summary>
        /// Закрываем текущее подключение к устройству, если есть таковое.
        /// </summary>
        public void Close()
        {
            if (specified_device != null)
            {
                specified_device.Dispose();
                specified_device = null;
                if (OnSpecifiedDeviceRemoved != null)
                    this.OnSpecifiedDeviceRemoved(this, new EventArgs());
            }
        }

        /// <summary>
        /// Проверка подключения и поддержание в открытом состоянии доступа к устройству.
        /// Подключение к первому подходящему устройству по PID\VID при условии, что
        /// DeviceProduct = null
        /// </summary>
        /// <param name="OpenState">Если надо поддерживать связь, то True</param>
        /// <returns>Возвращает True - если устройство успешно найденно, иначе False</returns>
        public bool Open(bool OpenState)
        {
            bool success = true;
            device_product = null;

            if (OpenState)
            {
                CheckDevicePresent();

                if (SpecifiedDevice == null)
                {
                    success = false;
                }
            }
            else
            {
                CheckDevicePresent();

                if (SpecifiedDevice != null)
                {
                    specified_device.Dispose();
                    specified_device = null;
                    this.OnSpecifiedDeviceRemoved(this, new EventArgs());
                }
                else
                {
                    success = false;
                }
            }
            return success;
        }

        /// <summary>
        /// Проверка подключения и поддержание в открытом состоянии доступа к устройству.
        /// Переподключение к устройству с подходящими PID\VID и соответствующим DeviceProduct
        /// </summary>
        /// <param name="OpenState">Если надо поддерживать связь, то True</param>
        /// <param name="Product">Указываем сюда глобальную константу DeviceProduct, с описанием продукта</param>
        /// <returns>Возвращает True - если устройство успешно найденно, иначе False</returns>
        public bool Open(bool OpenState, string Product)
        {
            bool success = true;

            if (OpenState)
            {
                CheckDevicePresent();

                if (SpecifiedDevice == null)
                {
                    success = false;
                }
            }
            else
            {
                CheckDevicePresent();

                if (SpecifiedDevice != null)
                {
                    specified_device.Dispose();
                    specified_device = null;
                    this.OnSpecifiedDeviceRemoved(this, new EventArgs());
                }
                else
                {
                    success = false;
                }
            }
            return success;
        }

        /// <summary>
        /// Переопределение строки продукта для устройства.
        /// При вызове происходит закрытие текущего подключения (если есть), далее происходит поиск и подключение к устройству с новыми параметрами.
        /// </summary>
        /// <param name="DevPrd">Указываем сюда глобальную константу DeviceProduct, с описанием продукта</param>
        /// <returns>Возвращает True - если устройство успешно найденно, иначе False</returns>
        public bool UpdateDeviceProduct(string Product)
        {
            bool success = true;

            if (specified_device != null)
            {
                specified_device.Dispose();
                specified_device = null;
                if (OnSpecifiedDeviceRemoved != null)
                    this.OnSpecifiedDeviceRemoved(this, new EventArgs());
            }

            device_product = Product;

            CheckDevicePresent();

            if (SpecifiedDevice == null)
            {
                success = false;
            }

            return success;
        }


        /// <summary>
        /// Чтение строк производителя и продукта из девайса.
        /// </summary>
        /// <param name="Manufacturer">Производитель</param>
        /// <param name="Product">Продукт</param>
        /// <returns>Возвращает True в случае успешного чтения обоих строк, иначе False</returns>
        public bool GetInfoStrings(ref string Manufacturer, ref string Product)
        {
            if (specified_device.GetManufacturerString(ref Manufacturer) &&
                specified_device.GetProductString(ref Product))
                return true;
            else
                return false;
        }
        #endregion

        #region Write Reports

        /// <summary>
        /// Записываем Output Report в девайс.
        /// </summary>
        /// <param name="ID">Report ID</param>
        /// <param name="data">Report Data</param>
        /// <returns>Возвращает True, если успешно отправленны данные,иначе False</returns>
        public bool WriteOutputReport(byte ID, byte[] data)
        {
            bool success = false;
            byte[] Report = new byte[specified_device.OutputReportLength];

            // Проверяем, влазит ли пакет данных
            try
            {
                Report[0] = ID;
                Array.Copy(data, Report, data.Length);
                success = true;
            }
            catch(Exception ex)
            {
                MessageBox.Show(ex.Message);
            }

            if (success)
            {
                try
                {
                    SpecifiedDevice.SendData(Report);
                }
                catch
                {
                    success = false;
                }
            }
            return success;
        }

        /// <summary>
        /// Записываем Feature Report в девайс.
        /// </summary>
        /// <param name="ID">Report ID</param>
        /// <param name="data">Report Data to Write</param>
        /// <param name="rdata">Report Data Received</param>
        /// <returns>Возвращает True, если успешно отправленны и полученны данные,иначе False</returns>
        public bool WriteFeatureReport(byte ID, byte[] data, ref byte[] rdata)
        {
            bool success = true;
            byte[] Report = new byte[specified_device.FeatureReportLength];
            
            // Проверяем, влазит ли пакет данных
            try
            {
                Report[0] = ID;
                Array.Copy(data, 0, Report, 1, data.Length);
            }
            catch
            {
                success = false;
            }
            
            if (success)
            {
                try
                {
                    rdata = new byte[specified_device.FeatureReportLength];
                    rdata = specified_device.SendFeature(Report, ref success);
                }
                catch
                {
                    success = false;
                }
            }
            return success;
        }
        #endregion
    }
}
