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
import MapKit
import Observation

@MainActor
@Observable
final class SearchViewModel {
    /// 選択中の検索半径（必須・デフォルトは1km）
    var selectedRange: SearchRange = .r1000
    
    /// 位置情報サービス
    let locationManager = LocationManager()
    
    /// 逆ジオコーディングで得られる地名（例：渋谷区、東京都）。未取得の場合は：nil
    private(set) var locationName: String?
        
    /// 現在の許可状態
    var authorizationStatus: CLAuthorizationStatus {
        locationManager.authorizationStatus
    }
    
    /// 取得した現在地の座標（未取得ならnil）
    var coordinate: CLLocationCoordinate2D? {
        locationManager.currentLocation?.coordinate
    }
    
    /// 検索結果の店舗一覧
    var shops: [Shop] = []
    /// 検索中フラグ
    var isLoading = false
    /// エラーメッセージ（なけらばnil）
    var errorMessage: String?
    
    private let apiClient = HotPepperAPIClient()
    
    /// 現在地と検索半径で飲食店を検索
    func search() async {
        guard let coordinate else {
            errorMessage = "現在地が取得できていません。位置情報を許可してください。"
            return
        }
        isLoading = true
        errorMessage = nil
        do {
            shops = try await apiClient.searchShops(coordinate: coordinate, range: selectedRange)
        } catch {
            errorMessage = error.localizedDescription
            shops = []
        }
        isLoading = false
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
            guard let request = MKReverseGeocodingRequest(location: location) else { return }
            let mapItems = try? await request.mapItems
            // 整形済みの短い住所を優先。なければ地点名にフォールバック
            let name = mapItems?.first?.address?.shortAddress ?? mapItems?.first?.name
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
