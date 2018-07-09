//
//  TemperatureDetector.swift
//  Sensei
//
//  Created by Sam Meech-Ward on 2018-07-08.
//  Copyright © 2018 meech-ward. All rights reserved.
//

import Foundation
import CoreBluetooth

protocol TemperatureDetectorDelegate {
  func temperatureDetector(_ temperatureDetector: TemperatureDetector, didGetTemperature temperature: Double, andHumidity humidity: Double)
}

class TemperatureDetector: NSObject {
  
  // The Central Manager is what will listen for advertising ble devices.
  var myCentralManager: CBCentralManager!
  
  var delegate: TemperatureDetectorDelegate?
  
  override init() {
    super.init()
    myCentralManager = CBCentralManager(delegate: self, queue: nil)
  }
  
  func scan() {
    // The advertising device is called a peripheral, so the pi in this case is the peripheral.
    myCentralManager.scanForPeripherals(withServices: nil, options: nil)
  }
  

}

extension TemperatureDetector: CBCentralManagerDelegate {
  func centralManagerDidUpdateState(_ central: CBCentralManager) {
    // If ble is supported and available, start scanning; otherwise, stop scanning
    if central.state == .poweredOn {
      scan()
    } else {
      myCentralManager.stopScan()
    }
  }
  
  func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
    
    // Only continue if we find a peripheral with the name "Sensei"
    guard let name = advertisementData["kCBAdvDataLocalName"] as? String, name == "Sensei" else {
      return
    }
    print(name)
    
    // Get the Manufacturer Data, that's where we stored the temperature and humidity
    guard let manData = advertisementData["kCBAdvDataManufacturerData"] as? Data else {
      return
    }
    
    // The data was stored in binary, now we have to read that data as an 8 byte double.
    // Temperature is the first 8 bytes
    let temperature: Double = manData.subdata(in: 0..<8).withUnsafeBytes { $0.pointee }
    // Humidity is the second 8 bytes
    let humidity: Double = manData.subdata(in: 8..<16).withUnsafeBytes { $0.pointee }
    
    // Send that data to the view controller
    delegate?.temperatureDetector(self, didGetTemperature: temperature, andHumidity: humidity)
  }
  
  
}
