//
//  HomeRepository.swift
//  StreamiSubject
//
//  Created by 이철우 on 2020/05/07.
//  Copyright © 2020 LeeCheolWoo. All rights reserved.
//

import Foundation
import ObjectMapper

class HomeRepository: Mappable, Equatable {
    
    /// 통화쌍
    var name: String = ""
    
    /// 가격
    var price: NSNumber = 0
    
    /// 매도호가
    var ask: NSNumber = 0
    
    /// 매도거래량
    var askVolume: NSNumber = 0
    
    /// 매수호가
    var bid: NSNumber = 0
    
    /// 매수 거랴량
    var bidVolume: NSNumber = 0
    
    /// 통화쌍거래량
    var volume: NSNumber = 0
    
    /// 시간
    var time: String = ""
    
    /// 상대통화
    var quoteAsset: String = ""
    
    /// 기준통화
    var baseAsset: String = ""
    
    required init() {
        
    }
    
    required init?(map: Map){
    
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        price <- map["price"]
        ask <- map["ask"]
        askVolume <- map["askVolume"]
        bid <- map["bid"]
        bidVolume <- map["bidVolume"]
        volume <- map["volume"]
        time <- map["time"]
    }
    
    public static func == (lhs: HomeRepository, rhs: HomeRepository) -> Bool {
        return lhs.name == rhs.name && lhs.price == rhs.price && lhs.ask == rhs.ask && lhs.askVolume == rhs.askVolume && lhs.bid == rhs.bid && lhs.bidVolume == rhs.bidVolume && lhs.volume == rhs.volume && lhs.time == rhs.time && lhs.quoteAsset == rhs.quoteAsset && lhs.baseAsset == rhs.baseAsset
    }
}
