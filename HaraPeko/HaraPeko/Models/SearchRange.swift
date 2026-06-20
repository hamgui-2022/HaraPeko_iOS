//
//  SearchRange.swift
//  HaraPeko
//
//  Created by 이재혁 on 6/20/26.
//
//  HotPepper グルメサーチAPIの検索半径パラメータ「range」(1~5)
//  画面の表示ラベルとAPI値を一箇所で対応付ける
//

import Foundation

enum SearchRange: Int, CaseIterable, Identifiable {
    case r300 = 1       // 300m
    case r500 = 2       // 500m
    case r1000 = 3      // 1km
    case r2000 = 4      // 2km
    case r3000 = 5      // 3km
    
    var id: Int { rawValue }
    
    /// セグメントに表示する主ラベル（数字部分）
    var title: String {
        switch self {
        case .r300:     "300"
        case .r500:     "500"
        case .r1000:    "1"
        case .r2000:    "2"
        case .r3000:    "3"
        }
    }
    
    /// 単位ラベル(m/km)
    var unit: String {
        switch self {
        case .r300, .r500:  "m"
        default:            "km"
        }
    }
    
    /// 表示用ラベル（例：300m, 1km）
    var label: String { title + unit }
}
