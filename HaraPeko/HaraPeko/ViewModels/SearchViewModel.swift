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

@MainActor
@Observable
final class SearchViewModel {
    /// 選択中の検索半径（必須・デフォルトは1km）
    var selectedRange: SearchRange = .r1000
    
    /// 選択中のジャンル（nil = すべて / 絞り込みなし）
    var selectedGenre: SearchGenre?
    
    /// 選択中の予算（nil = 指定なし）
    var selectedBudget: SearchBudget?
    
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
    /// 該当総件数（ページング終了判定に使用）
    var resultsAvailable = 0
    /// 検索中フラグ
    var isLoading = false
    /// 追加読み込み中フラグ
    var isLoadingMore = false
    /// エラーメッセージ（なけらばnil）
    var errorMessage: String?
    
    private let apiClient = HotPepperAPIClient()
    private let pageSize = 20
    
    /// まだ読み込める結果があるか
    var canLoadMore: Bool {
        shops.count < resultsAvailable
    }
    
    /// 現在地と検索半径で飲食店を検索
    func search() async {
        guard let coordinate else {
            errorMessage = "現在地が取得できていません。位置情報を許可してください。"
            return
        }
        isLoading = true
        errorMessage = nil
        do {
            let results = try await apiClient.searchShops(
                coordinate: coordinate,
                range: selectedRange,
                genre: selectedGenre,
                budget: selectedBudget,
                start: 1,
                count: pageSize
            )
            shops = results.shop
            resultsAvailable = results.resultsAvailable
        } catch {
            errorMessage = error.localizedDescription
            shops = []
            resultsAvailable = 0
        }
        isLoading = false
    }
    
    /// 次のページを読み込んで結果に追加
    func loadMore() async {
        guard !isLoadingMore, canLoadMore, let coordinate else { return }
        isLoadingMore = true
        do {
            let nextStart = shops.count + 1         // HotPepperのstartは１始まり
            
            let results = try await apiClient.searchShops(
                coordinate: coordinate,
                range: selectedRange,
                genre: selectedGenre,
                budget: selectedBudget,
                start: nextStart,
                count: pageSize
            )
            shops.append(contentsOf: results.shop)
            resultsAvailable = results.resultsAvailable
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoadingMore = false
    }
    
    /// 画面表示時に呼ぶ。位置情報の許可をリクエスト
    func onAppear() {
        locationManager.requestPermission()
    }
    
    /// 現在地の座標から地名を求める。座標が変わるたびにViewから呼ぶ
    private let geocoder = CLGeocoder()
    
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
