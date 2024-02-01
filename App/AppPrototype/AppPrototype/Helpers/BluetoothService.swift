//
//  BluetoothService.swift
//  AppPrototype
//
//  Created by Andrew on 11/24/23.
//

import Foundation
import CoreBluetooth

enum ConnectionStatus: String {
    case connected
    case disconnected
    case scanning
    case connecting
    case error
}

// CBUUID
// let hallSensorService: CBUUID = CBUUID(string: "4fafc201-1fb5-459e-8fcc-c5c9c331914b")
// let hallSensorCharacteristic: CBUUID = CBUUID(string: "beb5483e-36e1-4688-b7f5-ea07361b26a8")

let REMServiceCBUUID  = CBUUID(string:"4fafc201-1fb5-459e-8fcc-c5c9c331914b")
let weightCharacteristicCBUUID = CBUUID(string: "beb5483e-36e1-4688-b7f5-ea07361b26a8")
let therCharacteristicCBUUID = CBUUID(string: "f8a1ff64-1b80-4fb5-bcf8-66986168b370")

class BluetoothService: NSObject, ObservableObject {

    private var centralManager: CBCentralManager!

    // var hallSensorPeripheral: CBPeripheral?
    var weightSensorPeripheral: CBPeripheral?
    var therSensorPeripheral: CBPeripheral?
    
    @Published var peripheralStatus: ConnectionStatus = .disconnected
    
    // @Published var magnetValue: Int = 0
    @Published var weightValue: Float = 0
    @Published var therValue: Float = 0

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func scanForPeripherals() {
        peripheralStatus = .scanning
        centralManager.scanForPeripherals(withServices: nil)
    }

}

extension BluetoothService: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            print("CB Powered On")
            scanForPeripherals()
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        // Connect Peripheral
        if peripheral.name == "ESP32_REM" {
            print("Discovered \(peripheral.name ?? "no name")")
            //hallSensorPeripheral = peripheral
            weightSensorPeripheral = peripheral
            therSensorPeripheral = peripheral
            //centralManager.connect(hallSensorPeripheral!)
            centralManager.connect(weightSensorPeripheral!)
            peripheralStatus = .connecting
        }
        
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheralStatus = .connected

        peripheral.delegate = self
        peripheral.discoverServices([REMServiceCBUUID])
        centralManager.stopScan()
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        peripheralStatus = .disconnected
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        peripheralStatus = .error
        print(error?.localizedDescription ?? "no error")
    }

}

extension BluetoothService: CBPeripheralDelegate {
    // Discover Services
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service in peripheral.services ?? [] {
            if service.uuid == REMServiceCBUUID {
                print("found service for \(REMServiceCBUUID)")
                peripheral.discoverCharacteristics([weightCharacteristicCBUUID], for: service)
                peripheral.discoverCharacteristics([therCharacteristicCBUUID], for: service)
            }
        }
    }
    
    // Discover Characteristics For Service
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for characteristic in service.characteristics ?? [] {
            peripheral.setNotifyValue(true, for: characteristic)
            print("found characteristic, waiting on values.")
        }
    }
    
    // Update Value for Characteristic
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if characteristic.uuid == weightCharacteristicCBUUID {
            guard let data = characteristic.value else {
                print("No data received for \(characteristic.uuid.uuidString)")
                return
            }
            let byteArray = [UInt8](data)
              // weight return byte1 plus byte2 - 93
            let sensorData = Float(byteArray[0]) + Float(byteArray[1]) - 93;
            weightValue = sensorData
        }
        
        if characteristic.uuid == therCharacteristicCBUUID {
            guard let data = characteristic.value else {
                print("No data received for \(characteristic.uuid.uuidString)")
                return
            }
            let byteArray = [UInt8](data)
              // temp return byte2 plus byte3 - 24
            let sensorData = Float(byteArray[1]) + Float(byteArray[2]) - 24;
            therValue = sensorData
        }
        
    }

}
