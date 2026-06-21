<p align="center">
  <img src="HaraPeko/HaraPeko/Assets.xcassets/AppIcon.appiconset/AppIcon.png" width="120" alt="腹ペコフェンリル アイコン">
</p>

<h1 align="center">腹ペコフェンリル（HaraPeko）</h1>

<p align="center">近くの獲物（お店）を、すぐ仕留める。</p>

現在地周辺の飲食店を検索できる iOS アプリ。
ホットペッパー グルメサーチ API を利用しています。

## スクリーンショット

| 検索条件入力 | 検索結果 | 店舗詳細 |
|:---:|:---:|:---:|
| <img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-06-21 at 20 24 21" src="https://github.com/user-attachments/assets/ee572cd4-1a3c-458b-8d35-1e9dffb3377a" /> | <img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-06-21 at 20 24 32" src="https://github.com/user-attachments/assets/76050b0d-7837-487f-bb6a-2318d556aad8" /> | <img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-06-21 at 10 45 48" src="https://github.com/user-attachments/assets/db1b89fd-be0e-468e-8221-cfbd6f2674a0" /> |

## 主な機能
- GPS による現在地取得・逆ジオコーディング
- 検索半径・ジャンル・予算での絞り込み検索
- 検索結果一覧（ページング対応）
- 店舗詳細（写真・住所・営業時間など）
- 地図アプリ連携 / 共有 / 予約ページへの導線

## 技術スタック
- Swift / SwiftUI（MVVM）
- 状態管理：Observation（@Observable）
- 通信：URLSession + async/await（外部ライブラリ不使用）
- 位置・地図：CoreLocation / MapKit

## 動作環境
- iOS 18.0 以上
- Xcode 26.3

## セットアップ
1. リポジトリをクローン
2. `Config.example.xcconfig` をコピーして `Secrets.xcconfig` を作成
3. `Secrets.xcconfig` の `HOTPEPPER_API_KEY` に取得した API キーを設定
   （キーは [リクルートWEBサービス](https://webservice.recruit.co.jp/) で発行）
4. Xcode でビルド・実行

## ドキュメント
- 簡易仕様書：[簡易仕様書.md](簡易仕様書.md)

---
Powered by ホットペッパーグルメ Webサービス
