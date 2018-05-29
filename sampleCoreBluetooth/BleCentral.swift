//
//  BleCentral.swift
//  sampleCoreBluetooth
//
//  Created by Erica Awada on 2018/05/18.
//  Copyright © 2018年 Erica Awada. All rights reserved.
//
//central

import CoreBluetooth



class BleCentral: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    

    var _centralManager: CBCentralManager!
    var _peripheral: CBPeripheral!
    var _serviceUUID: CBUUID!
    var _characteristicUUID: CBUUID!
    var _characteristicForWrite: CBCharacteristic!
    
    //lightblue
    let kServiceUUID = "2a04cfbc-62df-11e8-adc0-fa7ae01bbebc"
    let kCharacteristicUUID = "2a04cfbc-62df-11e8-adc0-fa7ae01bbebc"
    
    
    //centralManager初期化
    //queue: nilだとUI, backgroundで動いて欲しいからdispatchqueue
    func setup() {
        _centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.global())
        _serviceUUID = CBUUID(string: kServiceUUID)
        _characteristicUUID = CBUUID(string: kCharacteristicUUID)
      
        
        
    }
  
    
    
    //start scan
    func startScan() {
        print("##### _centralManager.state: \(_centralManager.state.rawValue)")
        if _centralManager.state == .poweredOn {
            _centralManager.scanForPeripherals(withServices: [_serviceUUID], options: nil)
//            options: [CBCentralManagerScanOptionAllowDuplicatesKey: true]
//            何回も接続する
            
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
        
    }
    
    //peripheral接続後 service探索
    //service探索結果を受け取るためにdelegateセット
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        peripheral.delegate = self
        _peripheral.discoverServices([_serviceUUID])
        
    }
    
    //service発見するとよばれる
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        //探したら保存
        if error != nil {
            print("failed to discover service")
            disconnect()
            return
        }
        let services: NSArray = peripheral.services! as NSArray
        for service in services {
            let myService: CBService = service as! CBService
            _peripheral.discoverCharacteristics(nil, for: myService)
        }
        
    }
    
    
    //characteristic発見するとよばれる
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        if error != nil {

            disconnect()
            print("failed to discover characteristic")
            return
            
        }
            //writeのcharacteristicを探す　保存
            let characteristics = service.characteristics
            
            for cha: CBCharacteristic in characteristics! {
                if cha.uuid.isEqual(_characteristicUUID){
                    _characteristicForWrite = cha
                    print("save cha for write")
                }
            }
            
            if service.uuid == _serviceUUID {
                if _characteristicForWrite == nil {
                    disconnect()
                    print("faild to find write characteristic")
                    
                    return
                }
            }
            
        }
    
    //TODO:- 名前を送る
    //writeRequest
    func writeRequest() {
        
        let ud = UserDefaults.standard
        let attend = ud.integer(forKey: "Attendance")
        let value: UInt8 = UInt8(attend & 0xFF)
        let data = NSData(bytes: [value] as [UInt8], length: 1)
        print ("\(data)")
        
        if (_peripheral == nil){
            print("faild to write")
            return
        }
        _peripheral.writeValue(data as Data, for: _characteristicForWrite, type: .withResponse)
    }
    
    
    //TODO:- error for がでる
    //did write value で完了
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?){
        if error != nil {
            disconnect()
            print("error for write request")
            return
        } else {
            print("success")
        }
        
    }
    
    
    
    //peripheral接続失敗
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("failed to connect peripheral")
    }
    
    
    //誰が切ってるのか...
    //stop scanの後28秒放置でdis4
    //peripheralのproperty変えるとwarning→dis4
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("dis4")

        self._peripheral = nil
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
    

