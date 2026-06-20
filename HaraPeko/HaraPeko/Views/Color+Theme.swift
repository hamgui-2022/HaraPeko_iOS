//
//  Color+Theme.swift
//  HaraPeko
//
//  Created by 이재혁 on 6/20/26.
//
//  デザインシステム「腹ペコフェンリル」のカラートークン。
//  ダークモード基準。Foundation の定義をそのままコード化している。
//

import SwiftUI

// ShapeStyle に定義することで、.foregroundStyle(.hpEmber) のように
// ドット記法で使える。Self == Color 制約により Color.hpEmber でも参照可能。
extension ShapeStyle where Self == Color {

    /// 背景・キャンバス (#0B0B0D)
    static var hpBackground: Color { Color(hex: 0x0B0B0D) }
    /// カード・面 (#16161A)
    static var hpSurface: Color { Color(hex: 0x16161A) }
    /// 罫線・境界 (#2A2A31)
    static var hpLine: Color { Color(hex: 0x2A2A31) }
    /// 主テキスト (#FFFFFF)
    static var hpText: Color { .white }
    /// 副テキスト・キャプション (#9A9AA2)
    static var hpSubText: Color { Color(hex: 0x9A9AA2) }
    /// メインアクセント・CTA (#FF6A2B)
    static var hpEmber: Color { Color(hex: 0xFF6A2B) }
    /// 選択地・タグの薄い面 (ember 13%)
    static var hpEmberDim: Color { Color(hex: 0xFF6A2B, alpha: 0.13) }
    /// サブアクセント・予算/数値 (#E8C39E)
    static var hpMoon: Color { Color(hex: 0xE8C39E) }
}

extension Color {
    /// 16進数(0xRRGGBB)から Color を生成する。
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: alpha
        )
    }
}
