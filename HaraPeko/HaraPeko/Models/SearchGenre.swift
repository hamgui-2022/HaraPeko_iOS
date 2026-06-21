//
//  SearchGenre.swift
//  HaraPeko
//
//  Created by 이재혁 on 6/21/26.
//
//  検索条件のジャンル
//  rawValueは HotPeeerのジャンルコード
//

import Foundation

enum SearchGenre: String, CaseIterable, Identifiable {
    case ramen      = "G013"
    case izakaya    = "G001"
    case yakiniku   = "G008"
    case cafe       = "G014"
    case washoku    = "G004"
    case italian    = "G006"
    
    var id: String { rawValue }
    
    /// チップに表示する名称
    var name: String {
        switch self {
        case .ramen:        "ラーメン"
        case .izakaya:      "居酒屋"
        case .yakiniku:     "焼肉"
        case .cafe:         "カフェ"
        case .washoku:      "和食"
        case .italian:      "イタリアン"
        }
    }
}
