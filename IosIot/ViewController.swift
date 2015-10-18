//
//  ViewController.swift
//  IosIot
//
//  Created by Rawoof on 18/10/15.
//  Copyright © 2015 Rawoof. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController,CBCentralManagerDelegate,CBPeripheralDelegate {

    let seriveUUID = "Comes with the BLE Module "
    let writeCharacteristic = "Comes with the BLE Module"
    
    var centralManager:CBCentralManager!
    var ble:CBPeripheral!
    var characteristicToWrite : CBCharacteristic!
    
    @IBOutlet weak var uiSwitch: UISwitch!
    
    @IBAction func lightValueChanged(sender: UISwitch) {
        if(sender.on){
            print("Light 1 is ON")
            writeToBLE("Command to turn light 1 ON")
            
        }else{
            print("Light 1 is OFF")
            writeToBLE("Command to turn light 1 OFF")
        }
    }
    
    @IBAction func light2ValueChanged(sender: UISwitch) {
        if(sender.on){
            print("Light 2 is ON")
            writeToBLE("Command to turn light 2 ON")
            
        }else{
            print("Light 2 is OFF")
            writeToBLE("Command to turn light 2 OFF")
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func startScan(){
        centralManager.scanForPeripheralsWithServices([CBUUID(string: seriveUUID)], options: nil)
        
    }
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        if(peripheral.name != nil){
            print(peripheral.name)
        }else{
            print(peripheral.identifier.UUIDString)
        }
        
        ble = peripheral
        centralManager.stopScan()
        centralManager.connectPeripheral(ble, options: nil)
        
    }
    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        print("Connected device is : \(peripheral.name)")
        ble.delegate = self
        ble.discoverServices(nil)
        
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        for service in peripheral.services!{
           let wantedService = service as CBService
            if service.UUID == CBUUID(string: seriveUUID){
                    peripheral.discoverCharacteristics(nil, forService: wantedService)
            }
            
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        for characteristic in service.characteristics! {
            let wantedcharacteristic = characteristic as CBCharacteristic
            if (wantedcharacteristic.UUID == CBUUID(string: writeCharacteristic)){
                    characteristicToWrite = wantedcharacteristic
            }
            
        }
    }
    
    func writeToBLE(string:String){
//        let data = string.dataUsingEncoding(NSUTF8StringEncoding)
//        ble.writeValue(data!, forCharacteristic: characteristicToWrite, type: CBCharacteristicWriteType.WithResponse)
        
    }
        
    
    
    func centralManagerDidUpdateState(central: CBCentralManager) {
        if (central.state == CBCentralManagerState.PoweredOn){
            startScan()
        }else{
            
            let alertVC = UIAlertController(title: "Bluetooth Not Working", message: "Make sure that you are connected to the BLE Module", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
                
            })
            let action2 = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                print("Tapped on cancel")
                self.dismissViewControllerAnimated(true, completion: nil)
            })
            alertVC.addAction(action2)
            alertVC.addAction(action)
            
            
            self.presentViewController(alertVC, animated: true, completion: nil)
            
        }
    }

}

