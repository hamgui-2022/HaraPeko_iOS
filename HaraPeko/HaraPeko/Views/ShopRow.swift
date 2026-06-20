//
//  ShopRow.swift
//  HaraPeko
//
//  Created by 이재혁 on 6/20/26.
//
//  検索結果一覧の一行（店舗カード）
//  サムネイル・ジャンル・店舗名・アクセス・距離・予算を表示する
//

import SwiftUI

struct ShopRow: View {
    let shop: Shop
    let distance: String?       // 現在地からの距離（計算できなければnil）
    
    var body: some View {
        HStack(spacing: 12) {
            // サムネイル
            AsyncImage(url: URL(string: shop.photo.mobile.s)) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                Color.hpLine
            }
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 0) {
                Text(shop.genre.name)
                    .font(.pretendard(.semiBold, size: 10))
                    .foregroundStyle(.hpEmber)
                
                Text(shop.name)
                    .font(.pretendard(.bold, size: 15))
                    .foregroundStyle(.hpText)
                    .lineLimit(1)
                    .padding(.vertical, 2)
                
                HStack(spacing: 5) {
                    Image(systemName: "figure.walk")
                        .font(.system(size: 11))
                    
                    Text(shop.access).lineLimit(1)
                }
                .font(.pretendard(.regular, size: 11))
                .foregroundStyle(.hpSubText)
                
                HStack(spacing: 13) {
                    if let distance {
                        metric(icon: "arrow.left.and.right", text: distance)
                    }
                    if let budget = shop.budget?.name, !budget.isEmpty {
                        metric(icon: "yensign", text: budget)
                    }
                }
                .padding(.top, 6)
            }
            
            Spacer(minLength: 0)
        }
        .padding(11)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.hpSurface)
                .stroke(Color.hpLine, lineWidth: 1)
        )
    }
    
    /// 距離・予算などの小さな指標表示
    private func metric(icon: String, text: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 11))
                .foregroundStyle(.hpSubText)
            
            Text(text)
                .font(.pretendard(.bold, size: 11))
                .foregroundStyle(.hpMoon)
        }
    }
}
