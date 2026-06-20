//
//  Shop.swift
//  HaraPeko
//
//  Created by 이재혁 on 6/20/26.
//
// 飲食店１件分の情報（グルメサーチAPIのshop要素）
//

import Foundation

struct Shop: Decodable, Identifiable {
    let id: String
    let name: String        // 店舗名
    let address: String     // 住所
    let access: String      // アクセス
    let lat: Double         // 緯度
    let lng: Double         // 経度
    let genre: Genre
    let budget: Budget?
    let photo: Photo
    let open: String?       // 営業時間
    let close: String?     // 定休日
    let urls: URLs?
    
    struct Genre: Decodable {
        let name: String
        let catchCopy: String?
        enum CodingKeys: String, CodingKey {
            case name
            case catchCopy = "catch"    // "catch"はSwiftの予約語に近いので改名
        }
    }
    
    struct Budget: Decodable {
        let name: String?
        let average: String?
    }
    
    struct Photo: Decodable {
        let mobile: Mobile
        struct Mobile: Decodable {
            let l: String   // 大サイズURL（詳細画面用）
            let s: String   // 小サイズURL（一覧サムネイル用）
        }
    }
    
    struct URLs: Decodable {
        let pc: String
    }
}
