//
//  SearchViewModel.swift
//  HaraPeko
//
//  Created by 이재혁 on 6/20/26.
//
//  1️⃣ 検索条件入力画面の状態を管理する ViewModel
//  まずは、検索半径のみ。今後ジャンル・キーワード・予算などを追加
//

import Observation

@Observable
final class SearchViewModel {
    /// 選択中の検索半径（必須・デフォルトは1km）
    var selectedRange: SearchRange = .r1000
}
