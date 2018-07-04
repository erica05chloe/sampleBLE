//
//  ChangeAttend.swift
//  sampleCoreBluetooth
//
//  Created by Erica Awada on 2018/06/22.
//  Copyright © 2018年 Erica Awada. All rights reserved.
//

import UIKit

class ChangeAttend: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var textNumber: UITextField!
    @IBOutlet weak var textRemarks: UITextField!
    
    var ud = UserDefaults.standard
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textNumber.delegate = self
        textRemarks.delegate = self
        
        textNumber.placeholder = "半角数字"
        textRemarks.placeholder = "例) 会議　14:00"
        
    }
    
    
    //textField  returnで閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

    //前画面に戻る
    @IBAction func tapToBack(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //TODO:- 送信先入力
    //在席ボタン
    @IBAction func sittingSeat(_ sender: Any) {
       
    }
    
    //外出ボタン
    @IBAction func goOut(_ sender: Any) {
        
    }
    
    //離席ボタン
    @IBAction func leavingSeat(_ sender: Any) {
        
    }
    
    //退勤ボタン
    @IBAction func goHome(_ sender: Any) {
        
    }
}
