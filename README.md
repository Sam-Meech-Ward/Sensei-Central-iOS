# Sensei 

An iOS central for the Sensei temperature sensor: https://github.com/Sam-Meech-Ward/Sensei-Peripheral-JS

**You must run this on a real iPhone, not the simulator!**

## TemperatureDetector

The `TemperatureDetector` class contains all the magic for this app.

It uses `CoreBluetooth's` `CBCentralManager` class to listen for the Sensei peripheral advertising it's temperature and humidity.

Once it finds the ble device with the name `Sensei`, it grabs the manufacturer data using the `kCBAdvDataManufacturerData` flag and converts the data into doubles. It then passes the data on to its delegate.