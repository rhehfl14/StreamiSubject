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
    /// model
    let coinMaster = CoinMaster.sharedInstance
    let model: MainModel = MainModel()
    
    /// 통신 리시브 데이터
    let receiveData: [[String: String]] = []
    
//    / 현재 뷰
//    var curViewController: BaseViewController? = nil
    
    let screenObservable = PublishSubject<BaseViewController>()
    
    override init() {
        super.init()
        coinMaster.requestCoinMaster()
    }
    
    func mainScreen() {
        screenObservable.onNext(model.mainScreen(className: "HomeViewController"))
    }
}
