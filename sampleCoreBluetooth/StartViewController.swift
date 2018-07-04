//
//  StartViewController.swift
//  sampleCoreBluetooth
//
//  Created by Erica Awada on 2018/06/13.
//  Copyright © 2018年 Erica Awada. All rights reserved.
//

import UIKit

class StartViewController: UIViewController, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    
    //遷移を横にする
    
    
    //出・退勤ボタン
    @IBAction func attendBtn(_ sender: UIButton) {
        let secondVc = AttendanceView()
        show(secondVc, sender: nil)
    }
    
    //在籍状態変更ボタン
    @IBAction func changeBtn(_ sender: UIButton) {
        let thirdVc = ChangeAttend()
        show(thirdVc, sender: nil)
    }
    
    
    //社員一覧ボタン
    @IBAction func memberBtn(_ sender: UIButton) {
        let fourthVc = ShowMember()
        show(fourthVc, sender: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    


}
