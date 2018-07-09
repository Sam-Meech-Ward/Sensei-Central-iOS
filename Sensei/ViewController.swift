//
//  ViewController.swift
//  Sensei
//
//  Created by Sam Meech-Ward on 2018-07-08.
//  Copyright © 2018 meech-ward. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  var temperatureDetector: TemperatureDetector!

  @IBOutlet weak var humidityLabel: UILabel!
  @IBOutlet weak var temperatureLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    temperatureDetector = TemperatureDetector()
    temperatureDetector.delegate = self
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func twoDecimalPlaces(_ value: Double) -> Double {
    return Double(round(value * 100)) / 100.0
  }

}

extension ViewController: TemperatureDetectorDelegate {
  func temperatureDetector(_ temperatureDetector: TemperatureDetector, didGetTemperature temperature: Double, andHumidity humidity: Double) {
    print("temperature \(temperature), humidity \(humidity)")
    
    temperatureLabel.text = "\(twoDecimalPlaces(temperature))°"
    humidityLabel.text = "\(twoDecimalPlaces(humidity))%"
  }
}

