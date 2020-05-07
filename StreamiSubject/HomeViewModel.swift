//
//  HomeViewModel.swift
//  StreamiSubject
//
//  Created by 이철우 on 2020/05/02.
//  Copyright © 2020 LeeCheolWoo. All rights reserved.
//

import RxSwift
import RxCocoa
import RxAlamofire
import ObjectMapper

enum DataError: Error {
    case receiveDataError
}

class HomeViewModel: Base {
    /// model
    lazy var model: HomeModel = HomeModel(viewModel: self)

    /// 화면에 표시할 데이터 저장
    var receiveData: [HomeRepository] = []
        
    /// 저장 데이터 옵저버
    let receiveDataObservable = BehaviorSubject<[HomeRepository]>(value: [])
    
    override func requestComplete() {
        receiveDataObservable.onNext(receiveData)
    }
}

// MARK - DataRequest
extension HomeViewModel {
    /// 통신요청
    /// quoteAsset : KRW, BTC, ETH
    func requestData(quoteAsset: String) {
        receiveData.removeAll()
        model.requestData(quoteAsset: quoteAsset, firstRequest: true)
    }
}

// MARK: - Sort
extension HomeViewModel {
    func sortPrice(high: Bool) {
        model.sortPrice(high: high)
    }
    
    func sortVolume(high: Bool) {
        model.sortVolume(high: high)
    }
}
