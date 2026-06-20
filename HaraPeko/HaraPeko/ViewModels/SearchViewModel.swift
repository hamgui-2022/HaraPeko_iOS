//
//  SearchViewModel.swift
//  HaraPeko
//
//  Created by 이재혁 on 6/20/26.
//
//  1️⃣ 検索条件入力画面の状態を管理する ViewModel
//  まずは、検索半径のみ。今後ジャンル・キーワード・予算などを追加
//

import CoreLocation
import Observation

@Observable
final class SearchViewModel {
    /// 選択中の検索半径（必須・デフォルトは1km）
    var selectedRange: SearchRange = .r1000
    
    /// 位置情報サービス
    let locationManager = LocationManager()
    
    /// 現在の許可状態
    var authorizationStatus: CLAuthorizationStatus {
        locationManager.authorizationStatus
    }
    
    /// 取得した現在地の座標（未取得ならnil）
    var coordinate: CLLocationCoordinate2D? {
        locationManager.currentLocation?.coordinate
    }
    
    /// 画面表示時に呼ぶ。位置情報の許可をリクエスト
    func onAppear() {
        locationManager.requestPermission()
    }
}
