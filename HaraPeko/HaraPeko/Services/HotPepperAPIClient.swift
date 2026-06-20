//
//  HotPepperAPIClient.swift
//  HaraPeko
//
//  Created by 이재혁 on 6/20/26.
//
//  HotPepper グルメサーチAPIを呼び出すクライアント
//

import Foundation
import CoreLocation

enum HotPepperAPIError: LocalizedError {
    case invalidURL
    case requestFailed(statusCode: Int)
    case decodingFailed
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:               "リクエストの生成に失敗しました"
        case .requestFailed(let code):  "通信に失敗しました（コード：\(code)）"
        case .decodingFailed:           "データ解析に失敗しました"
        }
    }
}

struct HotPepperAPIClient {
    private let endpoint = "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/"
    
    /// 現在地と検索半径で飲食店を検索する
    func searchShops(coordinate: CLLocationCoordinate2D,
                     range: SearchRange) async throws -> [Shop] {
        guard var components = URLComponents(string: endpoint) else {
            throw HotPepperAPIError.invalidURL
        }
        components.queryItems = [
            URLQueryItem(name: "key", value: AppConfig.hotPepperAPIKey),
            URLQueryItem(name: "lat", value: String(coordinate.latitude)),
            URLQueryItem(name: "lng", value: String(coordinate.longitude)),
            URLQueryItem(name: "range", value: String(range.rawValue)),
            URLQueryItem(name: "count", value: "20"),
            URLQueryItem(name: "format", value: "json"),
        ]
        guard let url = components.url else {
            throw HotPepperAPIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let http = response as? HTTPURLResponse else {
            throw HotPepperAPIError.requestFailed(statusCode: -1)
        }
        guard 200..<300 ~= http.statusCode else {
            throw HotPepperAPIError.requestFailed(statusCode: http.statusCode)
        }
        
        do {
            return try JSONDecoder().decode(SearchResponse.self, from: data).results.shop
        } catch {
            throw HotPepperAPIError.decodingFailed
        }
    }
}
