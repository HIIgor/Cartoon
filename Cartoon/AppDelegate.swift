//
//  AppDelegate.swift
//  Cartoon
//
//  Created by xiangyaguo on 2020/5/1.
//  Copyright © 2020 HiIgor. All rights reserved.
//

import UIKit
import FLEX

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = TabBarController()
        window?.makeKeyAndVisible()
        
//        FLEXManager.shared()?.showExplorer()
        
        return true
    }
}

