//
//  SearchResponse.swift
//  HaraPeko
//
//  Created by 이재혁 on 6/20/26.
//
// グルメサーチAPIのレスポンス全体構造
//

import Foundation

struct SearchResponse: Decodable {
    let results: Results
    
    struct Results: Decodable {
        let resultsAvailable: Int       // 該当件数（ページング用）
        let shop: [Shop]                // 店舗一覧
        
        enum CodingKeys: String, CodingKey {
            case resultsAvailable = "results_available"
            case shop
        }
    }
}
