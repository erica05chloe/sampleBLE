//
//  AppDelegate.swift
//  sampleCoreBluetooth
//
//  Created by Erica Awada on 2018/05/11.
//  Copyright © 2018年 Erica Awada. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

//        let ud = UserDefaults.standard
//        let dict = ["firstLaunch": true]
//        ud.register(defaults: dict)
//
//        if ud.bool(forKey: "firstLaunch"){
//            ud.set(false, forKey: "firstLaunch")
//            print("初回起動")
//
//            let viewControllers = ViewController(nibName: "StartViewController", bundle: nil)
//            window = UIWindow(frame: UIScreen.main.bounds)
//            window?.rootViewController = viewControllers
//            window?.makeKeyAndVisible()
//
//            return true
        
//        }
//        print("初回起動ではない")
        
        //tabbar 配列
        var viewControllers: [UIViewController] = []

        //1ページ目
        let firstTab = AttendanceView()
        firstTab.tabBarItem = UITabBarItem(title: "attend", image: UIImage(named: "dash"), tag: 1)
        viewControllers.append(firstTab)

        //2ページ目
//        let secondTab = ChangeAttend()
//        secondTab.tabBarItem = UITabBarItem(title: "status", image: UIImage(named: "pin"), tag: 2)
//        viewControllers.append(secondTab)

        //3ページ目
//        let thirdTab = ShowMember()
//        thirdTab.tabBarItem = UITabBarItem(title: "list", image: UIImage(named: "desk"), tag: 3)
//        viewControllers.append(thirdTab)
        

        //セット
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers(viewControllers, animated: false)

        let colorKey = UIColor(red: 249/155, green: 161/255, blue: 188/255, alpha: 1.0)
        UITabBar.appearance().tintColor = colorKey

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

