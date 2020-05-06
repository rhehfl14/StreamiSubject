//
//  AppDelegate.swift
//  StreamiSubject
//
//  Created by 이철우 on 2020/04/30.
//  Copyright © 2020 LeeCheolWoo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.rootViewController = MainViewController.sharedInstance
        self.window?.makeKeyAndVisible()
        
        return true
    }

}

