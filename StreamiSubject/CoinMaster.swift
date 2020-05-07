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

typealias MasterType = [String: [CoinRepository]]

class CoinMaster: Base {
    
    /**
     * Singleton MainViewController
     */
    static let sharedInstance: CoinMaster = {
        var instance = CoinMaster.init()
        return instance
    }()
    
    /// 마스터 옵저버
    let coinMasterObservable = PublishSubject<MasterType>()
    
    /// 마스터
    var coinRepository: MasterType = ["": []]
    
    /// 코인 마스터 요청
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
                /// Base통화별로 통화쌍을 저장한다.
                if let array = self?.coinRepository[respository.quoteAsset], array.count != 0 {
                    
                    /// Base통화의 인덱스를 구분하기 위해 이전 인덱스에서 +1 한다.
                    let beforeData = array[array.count-1]
                    respository.index = beforeData.index+1
                    self?.coinRepository[respository.quoteAsset]?.append(respository)
                } else {
                    
                    /// Base통화 생성
                    respository.index = 0
                    self?.coinRepository.updateValue([respository], forKey: respository.quoteAsset)
                }
            }
            
            self?.coinMasterObservable.onCompleted()
            }).disposed(by: disposeBag)
        subject.onNext("https://api.gopax.co.kr/trading-pairs")
    }
}
