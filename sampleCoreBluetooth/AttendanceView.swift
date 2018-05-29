//
//  AttendanceView.swift
//  sampleCoreBluetooth
//
//  Created by Erica Awada on 2018/05/18.
//  Copyright © 2018年 Erica Awada. All rights reserved.
//

import UIKit
import CoreBluetooth


class AttendanceView: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var bleCentral = BleCentral()
    var ud = UserDefaults.standard
    
    @IBOutlet weak var cameraView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    //name 選択？　入力？
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var selectAttend: UIPickerView!
   
    
    var attend = ["出社", "退社"]
    
    
    //確認用
    private var imageData: NSData!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textName.delegate = self
        selectAttend.dataSource = self
        selectAttend.delegate = self
        
    
        initViews()
        bleCentral.setup()
        
        
        textName.text = loadName()
    
    }
  
    @IBAction func startScan(_ sender: UIButton) {
        
        bleCentral.startScan()
        
    }
    
    
    
//    userDefaults読込
    func loadName() -> String {
        let str: String = ud.object(forKey: "UserName") as! String

        return str
    }
    
    
    
    //camera -> peripheral側でする
    @IBAction func startCamera(_ sender: Any) {
        
        let sourceType: UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.camera
        
        //利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            
            //インスタンス
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
        } else {
            label.text = "permit to use camera"
        }
    }
    
    //撮影完了
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            cameraView.contentMode = .scaleAspectFit
            cameraView.image = pickedImage
           
          }
        
        //close camera
        picker.dismiss(animated: true, completion: nil)
    }
        
    
    //textfield
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //returnで閉じる
        textField.resignFirstResponder()
        return true
    }
    
    
    //selectAttend
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return attend.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return attend[row]
    }
    
    
    //pickerview選択した時
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("\(attend[row])")
        
        //0 == 出社
        //1 == 退社
        
        if attend[row] == "出社" {

            ud.set(0, forKey: "Attendance")
            
        } else {

            ud.set(1, forKey: "Attendance")
       }
        
    }


    
    //validationCheck
     private func validationCheck() -> Bool {
        
        //name 空文字check
        if let text = textName.text {
            if text.utf8.count > 0 {
            
                nameLabel.text = ""
                //userdefaultに追加
                ud.set(text, forKey: "UserName")
                return true
                
            } else {
                nameLabel.text = "write your name"
                ud.set(text, forKey: "UserName")
                return false
            }
        }
        
        //pickerView
        
        
        
        //camera
        if imageData != nil {
            return true
        } else {
            label.text = "take a photo"
            return false
        }
        
        
        
    }
    
    private func initViews() {
        
    }
    
    
    
    //送信ボタン
    //アラートor固定側(pceripheral)での反応
    @IBAction func tapToSend(_ sender: AnyObject) {
        if validationCheck() {
        
        //TODO:- write request
//            var attend = ud.integer(forKey: "Attendance")
//            var value: UInt8 = UInt8(attend & 0xFF)
//            var data = NSData(bytes: [value] as [UInt8], length: 1)
            
        bleCentral.writeRequest()
            
        
        bleCentral.stopScan()
            
//        } else {
//            let alert: UIAlertController = UIAlertController(title: "ERROR", message: "入力内容を確認してください", preferredStyle: UIAlertControllerStyle.alert)
//            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
//                (action: UIAlertAction!) -> Void in } )
//
//            alert.addAction(defaultAction)
//
        }

    }
    
}

