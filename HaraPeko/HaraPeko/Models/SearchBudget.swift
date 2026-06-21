//
//  SearchBudget.swift
//  HaraPeko
//
//  Created by 이재혁 on 6/21/26.
//
//  検索条件の予算
//  rawValueは ホットペッパーディナー予算マスタコード
//

import Foundation

enum SearchBudget: String, CaseIterable, Identifiable {
    case b010 = "B010"
    case b011 = "B011"
    case b001 = "B001"
    case b002 = "B002"
    case b003 = "B003"
    case b008 = "B008"
    
    var id: String { rawValue }
    
    /// チップに表示する名称（マスタの nameに準拠）
    var name: String {
        switch self {
        case .b010: "501~1000円"
        case .b011: "1001~1500円"
        case .b001: "1501~2000円"
        case .b002: "2001~3000円"
        case .b003: "3001~4000円"
        case .b008: "4001~5000円"
        }
    }
}
