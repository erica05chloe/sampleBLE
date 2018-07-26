//
//  BleCentral.swift
//  sampleCoreBluetooth
//
//  Created by Erica Awada on 2018/05/18.
//  Copyright © 2018年 Erica Awada. All rights reserved.
//
//central

import CoreBluetooth
import UIKit


var indicateFlg = false
var bleFlg = false


class BleCentral: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    var _centralManager: CBCentralManager!
    var _peripheral: CBPeripheral!
    var _serviceUUID: CBUUID!
    var _characteristicUUID: CBUUID!
    var _indiCharaUUID: CBUUID!
    
    var _characteristicForWrite: CBCharacteristic!
    var _characteristicForIndicate: CBCharacteristic!
    
    
    let kServiceUUID = "2a04cfbc-62df-11e8-adc0-fa7ae01bbebc"
    let kCharacteristicUUID = "2a04cfbc-62df-11e8-adc0-fa7ae01bbebc"
    let kindiCharaUUID = "2a04cfbc-62df-11e8-adc0-fa7ae01bbebd"

    
    //centralManager初期化
    //queue: nilだとUI, backgroundで動いて欲しいからdispatchqueue
    func setup() {
        _centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.global())
        _serviceUUID = CBUUID(string: kServiceUUID)
        _characteristicUUID = CBUUID(string: kCharacteristicUUID)
        _indiCharaUUID = CBUUID(string: kindiCharaUUID)
    
    }
    
    
    //start scan
    func startScan() {
        print("##### _centralManager.state: \(_centralManager.state.rawValue)")
        if _centralManager.state == .poweredOn {
            _centralManager.scanForPeripherals(withServices: [_serviceUUID])
//            options: [CBCentralManagerScanOptionAllowDuplicatesKey: true] -- 何回も接続される
            
            print("start scan")
        }
    }

    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("##### _centralManager.state: \(_centralManager.state.rawValue)")
        
    }
    
    
    //peripheral発見するとよばれる
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("find peripheral")
        
        _peripheral = peripheral

        print("\(peripheral)")
        print("\(advertisementData)")
        
        //接続開始
        _centralManager.connect(_peripheral, options: nil)
        print("connect peripheral")
        
        stopScan()
    }
    
    //peripheral接続後 service探索
    //service探索結果を受け取るためにdelegateセット
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        peripheral.delegate = self
        _peripheral.discoverServices([_serviceUUID])
        
    }
    
    //service発見するとよばれる
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
    
        if error != nil {
            print("failed to discover service")
            disconnect()
            return
        }
        let services: NSArray = peripheral.services! as NSArray
        for service in services {
            let myService: CBService = service as! CBService
            _peripheral.discoverCharacteristics(nil, for: myService)
            print("サービス発見")
        }
        
    }
    
    
    //characteristic発見するとよばれる
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        if error != nil {

            disconnect()
            print("failed to discover characteristic")
            bleFlg = false
            return
            
        }
            //writeのcharacteristicを探す
            let characteristics = service.characteristics
            
            for cha: CBCharacteristic in characteristics! {
                if cha.uuid.isEqual(_characteristicUUID){
                    _characteristicForWrite = cha
                    print("sキャラ発見: \(cha)")
                    bleFlg = true
    
                } else if cha.uuid.isEqual(_indiCharaUUID){
                    _characteristicForIndicate = cha
                    print("save indicate cha: \(cha)")
                    bleFlg = true
                }
            }
            
            if service.uuid == _serviceUUID {
                if _characteristicForWrite == nil {
                    disconnect()
                    print("faild to find write characteristic")
                    
                    return
                } else {
                    print("writerequestした")
                    self.writeRequest()
                }
            }
        
    }
    
    
    //writeRequest
    func writeRequest() {
        
        let ud = UserDefaults.standard
//        let attend = ud.integer(forKey: "Attendance")
        let number = ud.integer(forKey: "Number")
        print(number)
//        let attendValue: UInt8 = UInt8(attend & 0xff)
        let numberValue: UInt16 = UInt16(number & 0xffff)
        print(numberValue)
        
//        let attendData = NSData(bytes: [attendValue] as [UInt8], length: 1)
        let numberData = NSData(bytes: [numberValue] as [UInt16], length: 2)
//        print(attendData)
        print(numberData)
        
        var data: Data {
            var data = Data()
//            data.append(attendValue)
            //1byteずつ分割して送信
            data.append(UInt8(numberValue >> 8))
            data.append(UInt8(numberValue & 0xff))
            return data
        }
        
        //indicateFlgの状態を変える
        indicateFlg = false
        
        if (_peripheral == nil){
            print("faild to write request")
            return
        }
        
        _peripheral.writeValue(data, for: _characteristicForWrite, type: .withResponse)
        print("writeRequest成功")

    }
    
    
    //did write value で完了
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?){
        
        
        if error != nil {
            disconnect()
            print("faild to write")
            return
        } else {
            
            //indicate 受け取るためのセット
            _peripheral.setNotifyValue(true, for: _characteristicForIndicate)
            print("success")
            
        }
        
    }

    
    //characteisticのvalueが変化 indicate
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        if error != nil{
            disconnect()
            print("更新通知エラー \(String(describing: error))")
        } else {
            
            indicateFlg = true
            
            print("更新通知get")
            
            _peripheral.setNotifyValue(false, for: _characteristicForIndicate)
            
        }
    }
    
    //peripheral接続失敗
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("failed to connect peripheral")
    }
    
    //TODO:- 30秒放置で切れる
    //接続が切れたとき
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("dis4")
    }

    
    //disconnect peripheral
    func disconnect() {
        _centralManager.cancelPeripheralConnection(_peripheral)
        print("disconnect peripheral")
    }
    
    
    //stop scan
    func stopScan() {
        _centralManager.stopScan()
        print("stop scan")
    }


}
