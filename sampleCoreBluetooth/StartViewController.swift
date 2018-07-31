//
//  StartViewController.swift
//  sampleCoreBluetooth
//
//  Created by Erica Awada on 2018/07/24.
//  Copyright © 2018年 Erica Awada. All rights reserved.
//

import UIKit

class StartViewController: UIViewController, UITextFieldDelegate {


    @IBOutlet weak var ownNumber: UITextField!
    var ud = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ownNumber.delegate = self
        ownNumber.placeholder = "半角数字(eg:001)"
        if ud.object(forKey: "Number") != nil {
            ownNumber.text = "\(ud.object(forKey: "Number") ?? String.self)"
        }
    }
    
   

    //textField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func sendNum(_ sender: Any) {
        if validationCheck() {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //validation check
    func validationCheck() -> Bool {
        var result = true
        if let text = ownNumber.text
        {
            if text.count > 0 && text.count < 4 {
                let predicate = NSPredicate(format: "SELF MATCHES '\\\\d+'")
                ud.set(text, forKey: "Number")
                result = predicate.evaluate(with: text)
            } else {
                result = false
            }
        }
        if result == false{
            alert()
            ownNumber.text = ""
        }
        return result
    }

    //入力内容エラーアラート
    func alert() {
        let alert: UIAlertController = UIAlertController(title: "ERROR", message: "入力内容を確認してください", preferredStyle: UIAlertControllerStyle.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            (action: UIAlertAction!) -> Void in } )
        
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
        
    }

}
