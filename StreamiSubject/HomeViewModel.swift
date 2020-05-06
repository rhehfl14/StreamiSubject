//
//  HomeViewModel.swift
//  StreamiSubject
//
//  Created by 이철우 on 2020/05/02.
//  Copyright © 2020 LeeCheolWoo. All rights reserved.
//

import RxSwift
import RxCocoa

class HomeViewModel: Base {
    /// model
    lazy var model: HomeModel = HomeModel(viewModel: self)

    let receiveData = BehaviorSubject<[CoinRepository]>(value: [])
    
    /// requestData
    /// index 0 : KRW
    /// index 1 : BTC
    /// index 2 : ETH
    func requestData(index: NSInteger) {
        model.requestData(index: index)
    }
}
