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
    
    /// Command전달을 위한 ViewModel
    weak var viewModel: HomeViewModel?
    
    /// Threadsafe 요청 배열
    var requestArray = SynchronizedArray<CoinRepository>()
    
    /// Threadsafe 데이터 저장 배열
    var receiveArray = SynchronizedArray<HomeRepository>()
    
    required init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - quoteAsset: 기준 통화
    ///   - firstRequest: 첫 요청
    public func requestData(quoteAsset: String, firstRequest: Bool = false) {
        guard let viewModel = self.viewModel else {
            return
        }
        
        guard let guardArray = CoinMaster.sharedInstance.coinRepository[quoteAsset] else {
            return
        }
        
        /// 첫 요청일 경우 저장 배열 초기화
        if firstRequest == true {
            requestArray.copy(newElement: guardArray)
            receiveArray.removeAll()
            
            /// 통화쌍 갯수만큼 미리 생성
            receiveArray.copy(newElement: [HomeRepository](repeating: HomeRepository(), count: guardArray.count))
        }
        
        /// 통화 쌍 데이터 요청, 사용후 Array에서 제거
        let data = requestArray.first()
        
        /// 저장 배열
        var name = ""
        let baseAsset = data?.baseAsset
        
        /// Observable.from으로 alamofire을 호출하면 요청이 진행되지 않음
        let subject = Observable.just(data!)
            .observeOn(MainScheduler.instance)
            /// 동시 요청시 많을 경우 서버에서 errorMessage = "Rate limit exceeded"; 발생,
            /// 단건씩 0.04초텀을 두고 요청
            .delay(.milliseconds(40), scheduler: MainScheduler.instance)
            .map({ (object) -> String in
                name = object.name
                return object.name
            })
            .do(onNext: { _ in
                IndicatorViewViewController.ShowIndicatorView(showActivityIndicator: true)
                
            })
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMapLatest({
                return RxAlamofire
                    .requestJSON(.get, "https://api.gopax.co.kr/trading-pairs/\($0)/ticker")
                    .debug()
                    .catchError({ error in
                        return Observable.never()
                    })
            })
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map({ (response, json) throws -> HomeRepository in
                if let repos = Mapper<HomeRepository>().map(JSONObject: json) {
                    return repos
                } else {
                    throw DataError.receiveDataError
                }
            })
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] mapper in
                
                /// 응답받은 데이터 저장
                mapper.name = name
                
                /// 기준통화와 상대통화 저장
                mapper.quoteAsset = quoteAsset
                mapper.baseAsset = baseAsset ?? ""
                
                /// 응답받은 데이터 저장
                self?.receiveArray[data!.index] = mapper
                
                }, onCompleted: ({ [weak self] in
                    self?.requestArray.removeAtIndex(index: 0)
                    if self?.requestArray.count == 0 {
                        
                        /// errorCode = 10105;
                        /// errorMessage = "Rate limit exceeded";
                        /// 방지용 인디케이터
                        DispatchQueue.main.asyncAfter(deadline: .now()+1.0, execute: {
                            IndicatorViewViewController.ShowIndicatorView(showActivityIndicator: false)
                        })
                        
                        /// 데이터 완료 시 ViewModel로 데이터 전달
                        viewModel.receiveData = (self?.receiveArray.arrayData())!
                        viewModel.requestComplete()
                    } else {
                        self?.requestData(quoteAsset: quoteAsset)
                    }
                }))
        
        subject.disposed(by: disposeBag)
    }
    
}

//MARK: - Sort
extension HomeModel {
    
    /// 가격정렬
    /// - Parameter high: true - 높은 가격
    public func sortPrice(high: Bool) {
        let sortArray = self.receiveArray.arrayData()
        let sortCompleteArray = sortArray.sorted { (s0, s1) -> Bool in
            if high == true {
                return s0.price.doubleValue > s1.price.doubleValue
            } else {
                return s0.price.doubleValue < s1.price.doubleValue
            }
        }
        
        viewModel?.receiveData.removeAll()
        viewModel?.receiveData = sortCompleteArray
        viewModel?.requestComplete()
    }
    
    /// 거래량정렬
    /// - Parameter high: true - 높은 거래량
    public func sortVolume(high: Bool) {
        let sortArray = self.receiveArray.arrayData()
        let sortCompleteArray = sortArray.sorted { (s0, s1) -> Bool in
            if high == true {
                return s0.volume.doubleValue > s1.volume.doubleValue
            } else {
                return s0.volume.doubleValue < s1.volume.doubleValue
            }
        }
        
        viewModel?.receiveData.removeAll()
        viewModel?.receiveData = sortCompleteArray
        viewModel?.requestComplete()
    }
}


/// ThreadSafe 배열
public class SynchronizedArray<T> {
    private var array: [T] = []
    private let accessQueue = DispatchQueue(label: "SynchronizedArray", attributes: .concurrent)
    
    public func copy(newElement: [T]) {
        self.accessQueue.async(flags:.barrier) {
            self.array = newElement
        }
    }
    
    public func append(newElement: T) {
        self.accessQueue.async(flags:.barrier) {
            self.array.append(newElement)
        }
    }
    
    public func removeAtIndex(index: Int) {
        self.accessQueue.async(flags:.barrier) {
            self.array.remove(at: index)
        }
    }
    
    public func removeAll() {
        self.accessQueue.sync {
            self.array.removeAll()
        }
    }
    
    public var count: Int {
        var count = 0
        self.accessQueue.sync {
            count = self.array.count
        }
        
        return count
    }
    
    public func first() -> T? {
        var element: T?
        
        self.accessQueue.sync {
            if !self.array.isEmpty {
                element = self.array[0]
            }
        }
        
        return element
    }
    
    public subscript(index: Int) -> T {
        set {
            self.accessQueue.async(flags:.barrier) {
                self.array[index] = newValue
            }
        }
        get {
            var element: T!
            self.accessQueue.sync {
                element = self.array[index]
            }
            
            return element
        }
    }
    
    public func arrayData() -> [T] {
        return self.array
    }
}
