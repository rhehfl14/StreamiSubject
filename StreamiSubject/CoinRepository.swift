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
    
    var id: Int = 0
    var name: String = ""
    var baseAsset: String = ""
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
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.baseAsset == rhs.baseAsset && lhs.quoteAsset == rhs.quoteAsset
    }
    
}
