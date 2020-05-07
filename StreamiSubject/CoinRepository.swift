//
//  CoinRepository.swift
//  StreamiSubject
//
//  Created by 이철우 on 2020/05/06.
//  Copyright © 2020 LeeCheolWoo. All rights reserved.
//

import Foundation
import ObjectMapper

class CoinRepository: Mappable, Equatable {
    
    /// 코인id
    var id: Int = 0
    
    /// 코인정렬
    var index: Int = 0
    
    /// 통화쌍
    var name: String = ""
    
    /// 기준통화
    var baseAsset: String = ""
    
    /// 상대통화
    var quoteAsset: String = ""
    
    required init?(map: Map){
    
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        baseAsset <- map["baseAsset"]
        quoteAsset <- map["quoteAsset"]
    }
    
    public static func == (lhs: CoinRepository, rhs: CoinRepository) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.baseAsset == rhs.baseAsset && lhs.quoteAsset == rhs.quoteAsset && lhs.index == rhs.index
    }
    
}
