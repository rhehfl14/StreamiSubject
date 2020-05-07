//
//  MainModel.swift
//  StreamiSubject
//
//  Created by 이철우 on 2020/04/30.
//  Copyright © 2020 LeeCheolWoo. All rights reserved.
//
import UIKit

class MainModel: Base {
    
    /// 현재 화면에 표시할 뷰 생성
    /// - Parameter className: 생성할 Class Name
    func mainScreen(className: String) -> BaseViewController {
        let appName = { (_ className: String) -> UIViewController in
            let classStringName: String = String(format: "%@.%@", Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String, className)
            let theClass: UIViewController.Type = NSClassFromString(classStringName) as! UIViewController.Type
            let toController: UIViewController = theClass.init(nibName: className, bundle: nil)
            return toController
        }
        let viewController = appName(className)
        return viewController as! BaseViewController
    }
}
