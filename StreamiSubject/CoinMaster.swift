//
//  CoinMaster.swift
//  StreamiSubject
//
//  Created by 이철우 on 2020/05/06.
//  Copyright © 2020 LeeCheolWoo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxAlamofire
import ObjectMapper

class CoinMaster: Base {
    
    /**
     * Singleton MainViewController
     */
    static let sharedInstance: CoinMaster = {
        var instance = CoinMaster.init()
        return instance
    }()
    
    let coinMasterObservable = PublishSubject<[String: [CoinRepository]]>()
    var coinRepository: [String: [CoinRepository]] = ["": []]
    
    public func requestCoinMaster() {
        let subject = PublishSubject<String>()
        subject.flatMapLatest({
            return RxAlamofire
                .requestJSON(.get, $0)
                .debug()
                .catchError({ error in
                    return Observable.never()
                })
        }).map({ (response, json) -> [CoinRepository] in
            if let repos = Mapper<CoinRepository>().mapArray(JSONObject: json) {
                return repos
            } else {
                return []
            }
        }).subscribe(onNext: { [weak self] mapper in
            self?.coinRepository.removeAll()
            
            for respository in mapper {
                if let array = self?.coinRepository[respository.quoteAsset], array.count != 0 {
                    self?.coinRepository[respository.quoteAsset]?.append(respository)
                } else {
                    self?.coinRepository.updateValue([respository], forKey: respository.quoteAsset)
                }
            }
            
            self?.coinMasterObservable.onCompleted()
            }).disposed(by: disposeBag)
        subject.onNext("https://api.gopax.co.kr/trading-pairs")
    }
}
