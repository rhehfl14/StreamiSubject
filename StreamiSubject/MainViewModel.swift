//
//  MainViewModel.swift
//  StreamiSubject
//
//  Created by 이철우 on 2020/04/30.
//  Copyright © 2020 LeeCheolWoo. All rights reserved.
//

import RxSwift
import RxCocoa

class MainViewModel: Base {
    /// Model
    let model: MainModel = MainModel()
    
    /// 마스터 요청
    let coinMaster = CoinMaster.sharedInstance
    
    let screenObservable = PublishSubject<BaseViewController>()
    
    override init() {
        super.init()
        coinMaster.requestCoinMaster()
    }
    
    /// 메인뷰 옵저버 전달
    func mainScreen() {
        screenObservable.onNext(model.mainScreen(className: "HomeViewController"))
    }
}
