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
  
  var myCentralManager: CBCentralManager!
  
  var delegate: TemperatureDetectorDelegate?
  
  override init() {
    super.init()
    myCentralManager = CBCentralManager(delegate: self, queue: nil)
  }
  
  func scan() {
    myCentralManager.scanForPeripherals(withServices: nil, options: nil)
  }
  

}

extension TemperatureDetector: CBCentralManagerDelegate {
  func centralManagerDidUpdateState(_ central: CBCentralManager) {
    if central.state == .poweredOn {
      scan()
    } else {
      myCentralManager.stopScan()
    }
  }
  
  func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
    
    guard let name = advertisementData["kCBAdvDataLocalName"] as? String, name == "Sensei" else {
      return
    }
    print(name)
    
    guard let manData = advertisementData["kCBAdvDataManufacturerData"] as? Data else {
      return
    }
    
    let temperature: Double = manData.subdata(in: 0..<8).withUnsafeBytes { $0.pointee }
    let humidity: Double = manData.subdata(in: 8..<16).withUnsafeBytes { $0.pointee }
    
    delegate?.temperatureDetector(self, didGetTemperature: temperature, andHumidity: humidity)
  }
  
  
}
