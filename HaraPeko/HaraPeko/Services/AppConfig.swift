//
//  AppConfig.swift
//  HaraPeko
//
//  アプリ全体の設定値（APIキーなど）への入り口。
//  キーの実体は Secrets.xcconfig にあり、ビルド時に Info.plist へ注入され、
//  実行時に Bundle 経由でここから読み取る。
//

import Foundation

enum AppConfig {
    /// HotPepper グルメサーチ API の認証キー。
    /// Info.plist の "HotPepperAPIKey"（= Secrets.xcconfig の値）を読み取る。
    static let hotPepperAPIKey: String = {
        guard
            let key = Bundle.main.object(forInfoDictionaryKey: "HotPepperAPIKey") as? String,
            !key.isEmpty,
            key != "your_api_key_here"
        else {
            fatalError(
                "HotPepper API キーが設定されていません。"
                + " Secrets.xcconfig に実際のキーを設定してください。"
            )
        }
        return key
    }()
}
