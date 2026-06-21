//
//  HotPepperCredit.swift
//  HaraPeko
//
//  Created by 이재혁 on 6/21/26.
//
//  ホットペッパーグルメWebサービスのクレジット表記（利用ガイドライン準拠）
//  https://webservice.recruit.co.jp/doc/hotpepper/guideline.html
//

import SwiftUI

struct HotPepperCredit: View {
    /// 画像を表記する画面では true
    var showsImageCredit: Bool = true
    
    var body: some View {
        VStack(spacing: 4) {
            Link(destination: URL(string:
                                    "https://webservice.recruit.co.jp/")!) {
                Text("Powered by ホットペッパーグルメ Webサービス")
                    .underline()
            }
            
            if showsImageCredit {
                Text("【画像提供：ホットペッパー グルメ】")
            }
        }
        .font(.pretendard(.regular, size: 10))
        .foregroundStyle(.hpSubText)
        .frame(maxWidth: .infinity)
        .multilineTextAlignment(.center)
    }
}

#Preview {
    HotPepperCredit()
}
