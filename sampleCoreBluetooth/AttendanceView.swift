//
//  AttendanceView.swift
//  sampleCoreBluetooth
//
//  Created by Erica Awada on 2018/05/18.
//  Copyright © 2018年 Erica Awada. All rights reserved.
//

import UIKit
import CoreBluetooth


class AttendanceView: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, BleCentralDelegate {
   
    var bleCentral = BleCentral()
    var ud = UserDefaults.standard
    
//    let image0 = UIImage(named: "crow1")
//    let image1 = UIImage(named: "crow2")
    var count = 0
   

    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var bleBtn: UIButton!
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        bleCentral.setup()
//        myLabel.text = "送信中やで！\n音がなったら成功！"
//        bleBtn.setImage(image0, for: UIControlState())
//        myLabel.text = "接続中です..."
//        Thread.sleep(forTimeInterval: 2)
//        bleCentral.startScan()
//        bleBtn.setImage(image1, for: UIControlState())
    
        //back to foreground
        NotificationCenter.default.addObserver(self, selector: #selector(catchNotification(notification:)), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if ud.object(forKey: "Number") == nil {
            print("ud ない")
            let vc = StartViewController()
            self.present(vc, animated: true, completion: nil)
            
        } else {
            print("ud ある")
        }
    }
    
    //画面に表示されるたび
    override func viewWillAppear(_ animated: Bool) {
        bleCentral.setup()
        myLabel.text = "送信中やで！\n音がなったら成功！"
        
        bleCentral.startScan()
        Thread.sleep(forTimeInterval: 2)
        if bleFlg == true {
            if ud.object(forKey: "Number") != nil {
                print("write request")
                return
            }

            while !indicateFlg {
                Thread.sleep(forTimeInterval: 1)
                if indicateFlg == true {
                    myLabel.text = "送信完了しました"
                    break
                } else {
                    myLabel.text = "送信失敗\nタップしてや"
                    break
                }
            }
        }
    }
    
    //when catch notification
    @objc func catchNotification(notification: Notification) -> Void {
        print("catchNotification")
        bleCentral.startScan()
        if ud.object(forKey: "Number") == nil {
            alert()
        } else {
            print("戻ってきてからの接続")
        }
    }
 
    @IBAction func funcBtn(_ sender: UIButton) {
        let nextVC = StartViewController()
        let naviVC = UINavigationController(rootViewController: nextVC)
        self.present(naviVC, animated: true, completion: nil)
    }
    
    @IBAction func startBLE(_ sender: AnyObject) {
        count += 1
        
        if(count%2 == 0) {
//            bleBtn.setImage(image0, for: UIControlState())
            bleCentral.stopScan()
            myLabel.text = "再接続はわいをタップするんや！！"
            
        } else if(count%2 == 1) {
//            bleBtn.setImage(image1, for: UIControlState())
            bleCentral.startScan()
            myLabel.text = "接続中やで"
            
            
//            while !bleFlg {
//                if bleFlg == true {
//                    print("chara発見")
//                    bleCentral.writeRequest()
//                    break
//                } else {
//                    print("chara見つからない")
//                    break
//                }
//            }
        }
    }
    
    //userDefaults loadName
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
    
    //入力エラーアラート
    func alert() {
        let alert: UIAlertController = UIAlertController(title: "ERROR", message: "社員番号を入力してください", preferredStyle: UIAlertControllerStyle.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            (action: UIAlertAction!) -> Void in } )
        
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)

    }
    
    func getIndicate() {
        myLabel.text = "送信完了"
    }
    
    func whenDisconnect(){
        myLabel.text = "接続が切れました。\nやり直すにはタップ"
    }
}
