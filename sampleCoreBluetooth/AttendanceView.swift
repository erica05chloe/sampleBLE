//
//  AttendanceView.swift
//  sampleCoreBluetooth
//
//  Created by Erica Awada on 2018/05/18.
//  Copyright © 2018年 Erica Awada. All rights reserved.
//

import UIKit
import CoreBluetooth


class AttendanceView: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    
    
    var bleCentral = BleCentral()
    var ud = UserDefaults.standard
    
    let image0 = UIImage(named: "crow1")
    let image1 = UIImage(named: "crow2")
    var count = 0

    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var bleBtn: UIButton!
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myLabel.text = " tap me !"
        textName.delegate = self
        textName.placeholder = "半角数字"

        bleCentral.setup()
        bleBtn.setImage(image0, for: UIControlState())
        
        if ud.object(forKey: "Number") == nil {
         textName.text = ""
    } else {
        textName.text = loadName()
        }
        
    }
  

    
    @IBAction func startBLE(_ sender: AnyObject) {
        count += 1
        
        if(count%2 == 0) {
            bleBtn.setImage(image0, for: UIControlState())
            bleCentral.stopScan()
            myLabel.text = "tap me !"
            
        } else if(count%2 == 1) {
            bleBtn.setImage(image1, for: UIControlState())
            bleCentral.startScan()
            myLabel.text = "connecting..."
        }
    }
    
//    userDefaults読込
    func loadName() -> String {
        
        let str: String = ud.object(forKey: "Number") as! String
        return str
    }
    
        
    
    //textField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //returnで閉じる
        textField.resignFirstResponder()
        return true
    }
    
    //入力制限
    //これかvalidationに半角checkを追加するか。
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        return string.isEmpty || string.range(of: "^[0-9]+$", options: .regularExpression, range: nil, locale: nil) != nil
//    }
    
    
    
    //validationCheck
    private func validationCheck() -> Bool {
        var result = true

        //number 空文字check
        //TODO:- 半角かどうか
        if let text = textName.text {
            if text.count > 0 {
            let predicate = NSPredicate(format: "SELF MATCHES '\\\\d+'")
            
                ud.set(text, forKey: "Number")
                result = predicate.evaluate(with: text)

            } else {
                result = false
          }
        }
            if result == false {
                alert()
            }
            return result
    }

    
    
    //入力エラーアラート
    func alert() {
        let alert: UIAlertController = UIAlertController(title: "ERROR", message: "入力内容を確認してください", preferredStyle: UIAlertControllerStyle.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            (action: UIAlertAction!) -> Void in } )
        
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)

    }
    
    //送信完了アラート
    func successAlert() {
        let alert: UIAlertController = UIAlertController(title: "SUCCESS", message: "送信完了", preferredStyle: UIAlertControllerStyle.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            (action: UIAlertAction!) -> Void in } )
        
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }

    
    //送信失敗アラート
    func faildAlert() {
        let alert: UIAlertController = UIAlertController(title: "ERROR", message: "送信失敗", preferredStyle: UIAlertControllerStyle.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{ (action: UIAlertAction!) -> Void in } )
        
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }

    
    
    //出勤ボタン
    @IBAction func inWork(_ sender: UIButton) {
        
        if bleFlg == true {
        if validationCheck() {
        ud.set(0, forKey: "Attendance")
            bleCentral.writeRequest()
        }
        
        while !indicateFlg {
            Thread.sleep(forTimeInterval: 0.5)
            print("処理まち")
            
            
            if indicateFlg == true {
                
                successAlert()
                
                ud.removeObject(forKey: "Attendance")
                bleBtn.setImage(image0, for: UIControlState())
                
                break
            } else {
                
                faildAlert()
                bleBtn.setImage(image0, for: UIControlState())

                break
            }
        }
        bleCentral.disconnect()
        myLabel.text = "stop connect"
            
        } else {
            faildAlert()
        }
    }
    
    
    //退勤ボタン
    @IBAction func outWork(_ sender: UIButton) {
        
        if bleFlg == true {
        if validationCheck() {
            ud.set(1, forKey: "Attendance")
            bleCentral.writeRequest()
        }
        
        while !indicateFlg {
            Thread.sleep(forTimeInterval: 0.5)
            print("処理まち")
            
            
            if indicateFlg == true {
               
                successAlert()
                
                ud.removeObject(forKey: "Attendance")
                bleBtn.setImage(image0, for: UIControlState())

                break
            } else {
                
                faildAlert()
                bleBtn.setImage(image0, for: UIControlState())
               
                break
            }
        }
        bleCentral.disconnect()
        myLabel.text = "stop connect"
            
        } else {
            faildAlert()
        }
    }
    
    
//    //前画面に戻る
//    @IBAction func tapToBack(_ sender: UIBarButtonItem) {
//        self.navigationController?.popViewController(animated: true)
//    }
    
    
    //送信ボタン
    //アラートor固定側(peripheral)での反応
//@IBAction func tapToSend(_ sender: AnyObject) {
//
//    if validationCheck() {
//
//        bleCentral.writeRequest()
//
//    //attendanceのud消す
//    ud.removeObject(forKey: "Attendance")
//
//    //"選択してください"に戻る
//        selectAttend.selectRow(0, inComponent: 0, animated: true)
//    }
//
//    //この辺でflgの状態知りたい
//    //ループさせる
//    while !indicateFlg {
//
//        //処理を一定時間止める
//        Thread.sleep(forTimeInterval: 0.3)
//        print("処理まち")
//
//
//    if indicateFlg == true {
//        let alert: UIAlertController = UIAlertController(title: "SUCCESS", message: "送信完了", preferredStyle: UIAlertControllerStyle.alert)
//        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
//            (action: UIAlertAction!) -> Void in } )
//
//        alert.addAction(defaultAction)
//        present(alert, animated: true, completion: nil)
//        print("とんでない！")
//        bleCentral.disconnect()
//
//
//        break
//
//    } else {
//
//        //faild to write request
//        let alert: UIAlertController = UIAlertController(title: "ERROR", message: "送信失敗", preferredStyle: UIAlertControllerStyle.alert)
//        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{ (action: UIAlertAction!) -> Void in } )
//
//        alert.addAction(defaultAction)
//        present(alert, animated: true, completion: nil)
//        print("とんでる(；ω；)")
//        break
//      }
//
//    }
//    bleCentral.stopScan()
//    }
//
    
}
