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
    
    /// 逆ジオコーディングで得られる地名（例：渋谷区、東京都）。未取得の場合は：nil
    private(set) var locationName: String?
    
    private let geocoder = CLGeocoder()
    
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
    
    /// 現在地の座標から地名を求める。座標が変わるたびにViewから呼ぶ
    func reverseGeocode() {
        guard let coordinate else {
            locationName = nil
            return
        }
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        Task {
            let placemarks = try? await geocoder.reverseGeocodeLocation(location, preferredLocale: Locale(identifier: "ja_JP"))
            let name = placemarks?.first.flatMap(Self.placeName(from:))
            await MainActor.run { locationName = name }
        }
    }
    
    /// CLPlacemarkから「市区町村、都道府県」形式の文字列を作る
    private static func placeName(from placemark: CLPlacemark) -> String? {
        let area = placemark.locality ?? placemark.administrativeArea
        guard let area else { return nil }
        if let admin = placemark.administrativeArea, admin != area {
            return "\(area), \(admin)"
        }
        return area
    }
}
