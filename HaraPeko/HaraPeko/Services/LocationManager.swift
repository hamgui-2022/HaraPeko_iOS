//
//  LocationManager.swift
//  HaraPeko
//
//  CLLocationManager をラップし、現在地と許可状態を SwiftUI へ公開するサービス。
//  @Observable にしているので、View 側でプロパティを参照するだけで自動更新される。
//

import CoreLocation
import Observation

@Observable
final class LocationManager: NSObject, CLLocationManagerDelegate {

    /// 位置情報の許可状態（未決定 / 許可 / 拒否 など）。
    private(set) var authorizationStatus: CLAuthorizationStatus

    /// 直近に取得できた現在地。未取得なら nil。
    private(set) var currentLocation: CLLocation?

    /// 位置取得に失敗したときのエラー。
    private(set) var locationError: Error?

    private let manager = CLLocationManager()

    override init() {
        authorizationStatus = manager.authorizationStatus
        super.init()
        manager.delegate = self
        // 飲食店検索には数百m精度で十分。電池消費も抑えられる。
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

    /// 位置情報の利用許可をリクエストする（初回はシステムのダイアログが出る）。
    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }

    /// 現在地を一度だけ取得する。結果は currentLocation / locationError に反映される。
    func requestLocation() {
        manager.requestLocation()
    }

    // MARK: - CLLocationManagerDelegate

    /// 許可状態が変わったとき（初回ダイアログへの回答含む）に呼ばれる。
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }

    /// 現在地の取得に成功したとき。
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
    }

    /// 現在地の取得に失敗したとき。
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationError = error
    }
}
