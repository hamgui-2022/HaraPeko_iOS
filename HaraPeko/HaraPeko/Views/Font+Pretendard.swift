//
//  Font+Pretendard.swift
//  HaraPeko
//
//  カスタムフォント Pretendard JP を SwiftUI で使うためのヘルパー。
//  使用例:
//      Text("腹ペコ").font(.pretendard(.bold, size: 24))
//

import SwiftUI

extension Font {

    /// Pretendard JP のウェイト。rawValue は Info.plist に登録した PostScript 名。
    enum Pretendard: String {
        case thin       = "PretendardJP-Thin"
        case extraLight = "PretendardJP-ExtraLight"
        case light      = "PretendardJP-Light"
        case regular    = "PretendardJP-Regular"
        case medium     = "PretendardJP-Medium"
        case semiBold   = "PretendardJP-SemiBold"
        case bold       = "PretendardJP-Bold"
        case extraBold  = "PretendardJP-ExtraBold"
        case black      = "PretendardJP-Black"
    }

    /// Pretendard JP フォントを生成する。
    /// - Parameters:
    ///   - weight: フォントウェイト（既定は regular）
    ///   - size: フォントサイズ
    ///   - textStyle: Dynamic Type の基準となるテキストスタイル（既定は body）。
    ///                これにより端末の文字サイズ設定に追従して拡大縮小する。
    static func pretendard(
        _ weight: Pretendard = .regular,
        size: CGFloat,
        relativeTo textStyle: TextStyle = .body
    ) -> Font {
        .custom(weight.rawValue, size: size, relativeTo: textStyle)
    }
}
