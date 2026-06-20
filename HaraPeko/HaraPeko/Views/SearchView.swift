//
//  SearchView.swift
//  HaraPeko
//
//  Created by 이재혁 on 6/20/26.
//
// ① 検索条件入力画面。現在地と検索半径などを指定して飲食店を検索する。
// この段階では、全体レイアウト（ヘッダー・スクロール領域・固定CTA）の骨組みのみ

import SwiftUI

struct SearchView: View {
    @State private var viewModel = SearchViewModel()
//
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // 画面全体の背景
            Color.hpBackground.ignoresSafeArea()
            
            // スクロールする検索条件エリア
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    brandHeader
                    
                    Text("検索条件を入力")
                        .font(.pretendard(.bold, size: 18))
                        .foregroundStyle(.hpText)
                    
                    radiusSection
                    
                    // TODO: 現在地カード／ジャンル／キーワード／予算
                }
                .padding(.horizontal, 18)
                .padding(.top, 8)
                .padding(.bottom, 120) // 固定CTAに隠れないよう余白を確保
            }
            
            searchButton
        }
    }
    
    // MARK: - ブランドヘッダー
    
    private var brandHeader: some View {
        HStack(spacing: 11) {
            // ロゴマーク（暫定：SF Symbols。後で専用アイコンに差し替え可能）
            ZStack {
                Circle().fill(Color.hpEmberDim)
                Image(systemName: "pawprint.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(.hpEmber)
            }
            .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("腹ペコフェンリル")
                    .font(.pretendard(.extraBold, size: 19))
                    .foregroundStyle(.hpText)
                Text("HUNT FOR YOUR MEAL")
                    .font(.pretendard(.semiBold, size: 9))
                    .tracking(1.5)
                    .foregroundStyle(.hpEmber)
            }
            
            Spacer()
            
            // 設定ボタン（暫定）
            Image(systemName: "gearshape")
                .font(.system(size: 20))
                .foregroundStyle(.hpText)
                .frame(width: 38, height: 38)
                .background(
                    RoundedRectangle(cornerRadius: 11)
                        .fill(Color.hpSurface)
                        .stroke(Color.hpLine, lineWidth: 1)
                )
        }
    }
    
    // MARK: - 検索半径セクション
    
    private var radiusSection: some View {
        VStack(alignment: .leading, spacing: 11) {
            HStack(spacing: 8) {
                Text("検索半径")
                    .font(.pretendard(.bold, size: 13))
                    .foregroundStyle(.hpText)
                
                Text("必須")
                    .font(.pretendard(.semiBold, size: 9))
                    .foregroundStyle(.hpEmber)
                    .padding(.horizontal, 7)
                    .padding(.vertical, 2)
                    .overlay(Capsule().stroke(Color.hpEmber, lineWidth: 1))
                
                Spacer()
                
                Text("API range 1-5")
                    .font(.system(size: 9, design: .monospaced))
                    .foregroundStyle(.hpSubText)
            }
            
            HStack(spacing: 6) {
                ForEach(SearchRange.allCases) { range in
                    radiusItem(range)
                }
            }
        }
    }
    
    private func radiusItem(_ range: SearchRange) -> some View {
        let isSelected = (viewModel.selectedRange == range)
        return Button {
            viewModel.selectedRange = range
        } label: {
            VStack(spacing: 1) {
                Text(range.title)
                    .font(.pretendard(isSelected ? .bold : .semiBold, size: 14))
                Text(range.unit)
                    .font(.pretendard(.medium, size: 9))
                    .opacity(0.75)
            }
            .foregroundStyle(isSelected ? Color.white : .hpSubText)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 13)
            .background(
                RoundedRectangle(cornerRadius: 13)
                    .fill(isSelected ? Color.hpEmber : Color.hpSurface)
                    .stroke(isSelected ? Color.hpEmber : Color.hpLine, lineWidth: 1)
            )
            .shadow(color: isSelected ? .hpEmber.opacity(0.3) : .clear, radius: 8, y: 6)
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - 検索ボタン（固定CTA）
    
    private var searchButton: some View {
        Button {
            // TODO: 検索を実行して結果画面へ移動（遷移）
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "pawprint.fill")
                    .font(.system(size: 20))
                Text("獲物を探す")
                    .font(.pretendard(.bold, size: 16))
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 17)
            .background(Color.hpEmber, in: RoundedRectangle(cornerRadius: 16))
            .shadow(color: .hpEmber.opacity(0.4), radius: 14, y: 10)
        }
        .padding(.horizontal, 18)
        .padding(.bottom, 30)
    }
}

#Preview {
    SearchView()
}
