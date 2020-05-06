//
//  ServiceManager.swift
//  StreamiSubject
//
//  Created by 이철우 on 2020/04/30.
//  Copyright © 2020 LeeCheolWoo. All rights reserved.
//

import UIKit
import Alamofire

class ServiceManager: NSObject {
    
    /**
     * Singleton ServiceManager
     */
    static let sharedInstance: ServiceManager = {
        var instance = ServiceManager()
        return instance
    }()

    
    
}
