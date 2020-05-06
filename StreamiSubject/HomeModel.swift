//
//  HomeModel.swift
//  StreamiSubject
//
//  Created by 이철우 on 2020/05/02.
//  Copyright © 2020 LeeCheolWoo. All rights reserved.
//

import Foundation
import RxAlamofire
import RxSwift
import RxCocoa
import ObjectMapper

class HomeModel: Base {
    
    weak var viewModel: HomeViewModel? = nil
    
    required init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    public func requestData(index: NSInteger) {
        
        
    }
    
    
    
}
